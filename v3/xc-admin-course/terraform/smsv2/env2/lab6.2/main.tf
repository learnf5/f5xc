# ============================================================
# SSH KEY PAIR
# ============================================================

resource "tls_private_key" "ce" {
  for_each = var.students

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ce" {
  for_each = var.students

  key_name   = "${each.key}-smsv2-key"
  public_key = tls_private_key.ce[each.key].public_key_openssh
}

resource "local_sensitive_file" "ssh_private_key" {
  for_each = var.students

  content         = tls_private_key.ce[each.key].private_key_openssh
  filename        = "${path.root}/${each.key}-smsv2-key.pem"
  file_permission = "0600"
}

# ============================================================
# SECURITY GROUPS (Auto-configured per student)
# ============================================================

resource "aws_security_group" "ce_slo" {
  for_each = var.students

  name        = "${each.key}-ce-slo-sg"
  description = "SLO security group for ${each.key}"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # LOCK THIS DOWN IF RESTRICTED IN COURSE
  }

  ingress {
    description = "All ICMP - IPv4"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    description = "Local UI Access"
    from_port   = 65500
    to_port     = 65500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # LOCK THIS DOWN IF RESTRICTED IN COURSE
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${each.key}-ce-slo-sg"
    Student = each.key
  }
}

resource "aws_security_group" "ce_sli" {
  for_each = var.students

  name        = "${each.key}-ce-sli-sg"
  description = "SLI security group for ${each.key}"
  vpc_id      = var.vpc_id

  ingress {
    description = "All from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${each.key}-ce-sli-sg"
    Student = each.key
  }
}

# ============================================================
# NETWORK INTERFACES
# ============================================================

resource "aws_network_interface" "ce_slo" {
  for_each = var.students

  subnet_id         = var.slo_subnet_id
  security_groups   = [aws_security_group.ce_slo[each.key].id]
  source_dest_check = false

  tags = {
    Name    = "${each.key}-ce-slo-eni"
    Student = each.key
  }
}

resource "aws_network_interface" "ce_sli" {
  for_each = var.students

  subnet_id         = var.sli_subnet_id
  security_groups   = [aws_security_group.ce_sli[each.key].id]
  source_dest_check = false

  tags = {
    Name    = "${each.key}-ce-sli-eni"
    Student = each.key
  }
}

# ============================================================
# ELASTIC IPs (Allocated on-demand and associated to SLO)
# ============================================================

resource "aws_eip" "ce_slo" {
  for_each = var.students

  domain = "vpc"

  tags = {
    Name    = "${each.key}-ce-slo-eip"
    Student = each.key
  }
}

resource "aws_eip_association" "ce_slo" {
  depends_on = [aws_eip.ce_slo, aws_network_interface.ce_slo]
  for_each   = var.students

  allocation_id        = aws_eip.ce_slo[each.key].id
  network_interface_id = aws_network_interface.ce_slo[each.key].id
}

# ============================================================
# CE INSTANCES
# ============================================================

resource "aws_instance" "ce_node" {
  for_each = var.students

  # Uses var.ce_ami_id if provided, otherwise defaults to dynamic lookup
  ami           = coalesce(var.ce_ami_id, data.aws_ami.f5xc_ce.id)
  instance_type = var.instance_type
  key_name      = aws_key_pair.ce[each.key].key_name

  user_data = <<-EOF
    #cloud-config
    write_files:
    - path: /etc/vpm/user_data
      content: |
        token: ${volterra_token.student[each.key].id}
        cluster_name: ${each.key}
        hostname: ${each.key}-ce
      owner: root
      permissions: '0644'
  EOF

  network_interface {
    network_interface_id = aws_network_interface.ce_slo[each.key].id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.ce_sli[each.key].id
    device_index         = 1
  }

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp3"
    delete_on_termination = true
  }

  # Explicit dependency — wait for the CE site, token, and EIP association
  depends_on = [
    volterra_securemesh_site_v2.student,
    volterra_token.student,
    time_sleep.token_ready,
    aws_eip_association.ce_slo
  ]

  tags = {
    Name    = "${each.key}-ce"
    Student = each.key
  }
}

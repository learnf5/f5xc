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
# VPCs — One per student
# ============================================================

resource "aws_vpc" "student" {
  for_each = var.students

  cidr_block           = each.value.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "${each.key}-vpc"
    Student = each.key
  }
}

# ============================================================
# INTERNET GATEWAYS — One per student VPC
# ============================================================

resource "aws_internet_gateway" "student" {
  for_each = var.students

  vpc_id = aws_vpc.student[each.key].id

  tags = {
    Name    = "${each.key}-igw"
    Student = each.key
  }
}

# ============================================================
# SUBNETS — SLO (public) and SLI (private) per student
# ============================================================

resource "aws_subnet" "slo" {
  for_each = var.students

  vpc_id                  = aws_vpc.student[each.key].id
  cidr_block              = each.value.slo_subnet_cidr
  availability_zone       = var.aws_az
  map_public_ip_on_launch = true

  tags = {
    Name    = "${each.key}-slo-subnet"
    Student = each.key
  }
}

resource "aws_subnet" "sli" {
  for_each = var.students

  vpc_id            = aws_vpc.student[each.key].id
  cidr_block        = each.value.sli_subnet_cidr
  availability_zone = var.aws_az

  tags = {
    Name    = "${each.key}-sli-subnet"
    Student = each.key
  }
}

# ============================================================
# ROUTE TABLES
# ============================================================

resource "aws_route_table" "slo" {
  for_each = var.students

  vpc_id = aws_vpc.student[each.key].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.student[each.key].id
  }

  tags = {
    Name    = "${each.key}-slo-rt"
    Student = each.key
  }
}

resource "aws_route_table_association" "slo" {
  for_each = var.students

  subnet_id      = aws_subnet.slo[each.key].id
  route_table_id = aws_route_table.slo[each.key].id
}

resource "aws_route_table" "sli" {
  for_each = var.students

  vpc_id = aws_vpc.student[each.key].id

  tags = {
    Name    = "${each.key}-sli-rt"
    Student = each.key
  }
}

resource "aws_route_table_association" "sli" {
  for_each = var.students

  subnet_id      = aws_subnet.sli[each.key].id
  route_table_id = aws_route_table.sli[each.key].id
}

# ============================================================
# SECURITY GROUPS
# ============================================================

resource "aws_security_group" "ce_slo" {
  for_each = var.students

  name        = "${each.key}-ce-slo-sg"
  description = "SLO security group for ${each.key}"
  vpc_id      = aws_vpc.student[each.key].id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # LOCK THIS DOWN
  }

  ingress {
    description = "All ICMP - IPv4"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"] # LOCK THIS DOWN
  }

  ingress {
    description = "Local UI Access"
    from_port   = 65500
    to_port     = 65500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # LOCK THIS DOWN
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
  vpc_id      = aws_vpc.student[each.key].id

  ingress {
    description = "All from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [each.value.vpc_cidr]
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

  subnet_id         = aws_subnet.slo[each.key].id
  security_groups   = [aws_security_group.ce_slo[each.key].id]
  source_dest_check = false

  tags = {
    Name    = "${each.key}-ce-slo-eni"
    Student = each.key
  }
}

resource "aws_network_interface" "ce_sli" {
  for_each = var.students

  subnet_id         = aws_subnet.sli[each.key].id
  security_groups   = [aws_security_group.ce_sli[each.key].id]
  source_dest_check = false

  tags = {
    Name    = "${each.key}-ce-sli-eni"
    Student = each.key
  }
}

# ============================================================
# ELASTIC IPs
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
# CE INSTANCES — Token now comes from volterra_token resource
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
        hostname: ${each.key}-ce-node
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

  # Explicit dependency — don't launch until site object and token exist
  # Explicit dependency - wait for the CE site and token to become usable before bootstrapping the CE node
  depends_on = [
    volterra_securemesh_site_v2.student,
    volterra_token.student,
    time_sleep.token_ready
  ]

  tags = {
    Name    = "${each.key}-ce-node"
    Student = each.key
  }
}


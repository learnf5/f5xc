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
# NETWORK INTERFACES
# ============================================================

resource "aws_network_interface" "ce_slo" {
  for_each = var.students

  subnet_id         = var.existing_network[each.key].slo_subnet_id
  security_groups   = [var.existing_network[each.key].slo_security_group]
  source_dest_check = false

  tags = {
    Name    = "${each.key}-ce-slo-eni"
    Student = each.key
  }
}

resource "aws_network_interface" "ce_sli" {
  for_each = var.students

  subnet_id         = var.existing_network[each.key].sli_subnet_id
  security_groups   = [var.existing_network[each.key].sli_security_group]
  source_dest_check = false

  tags = {
    Name    = "${each.key}-ce-sli-eni"
    Student = each.key
  }
}

resource "aws_eip_association" "ce_slo" {
  depends_on = [aws_network_interface.ce_slo]
  for_each   = var.students

  allocation_id        = var.existing_network[each.key].slo_eip_allocation
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



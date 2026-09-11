output "student_ce_details" {
  description = "CE deployment details per student"
  value = {
    for student, config in var.students : student => {
      public_ip      = aws_eip.ce_slo[student].public_ip
      slo_private_ip = aws_network_interface.ce_slo[student].private_ip
      sli_private_ip = aws_network_interface.ce_sli[student].private_ip
      instance_id    = aws_instance.ce_node[student].id
      vpc_id         = aws_vpc.student[student].id
      site_name      = volterra_securemesh_site_v2.student[student].name
      token_name     = volterra_token.student[student].name
    }
  }
  sensitive = false
}

output "ssh_private_key_openssh" {
  description = "Generated private SSH key per student; handle as a secret"
  value = {
    for student in keys(var.students) : student => tls_private_key.ce[student].private_key_openssh
  }
  sensitive = true
}

output "ssh_private_key_file_paths" {
  description = "Local filesystem paths of the generated private SSH key files"
  value = {
    for student in keys(var.students) : student => local_sensitive_file.ssh_private_key[student].filename
  }
}

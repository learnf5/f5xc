locals {
  loc_namespace = var.my_namespace
  loc_my_machine = "Standard_D3_v2"
  loc_my_region = "eastus"
  loc_my_resource_group = "${var.my_namespace}-rg"
  loc_my_ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDc+HSquvm6Bbvnk4h2KMR51MwnzBPWzbmhK5tiW8sC4rh+VzrcjNgnrc4Op7tFtLkv2sq/Vecg9QB6jMamGoBrqWP3qjejSxYWwr8xP/ZNRlqJNwGxEAQlDkUkKtUfNWgmOZtoVq249vvewyUCbmOlpgFDPPeNGfQrutJkOHmUj53kEIhhkoE+ZieY2Ls5fHTNgUDznf8KysnrIAr+reEKt7FREL+4kKnCp9ZlZtw/nw5sSDFNU9PRZuTwZIE85oY9nDxe9fRRttBSMHq9g0GD0iZg9fjafuB0Ft7qzkSq20vGrtYxfGgPW8kIjZBA95CSyA2gRsnSxUF7Fq+W50EWZfqU4O9KOZwKo8dTcbjmS+S5S5avK37uVn1v99rdG3Z9xbfBW8tohARDGlzC1R1Qh+LrfPgjds7oKXewT6hiHDe0wsMp25IxYUGEHqdEaAs4Bfos4Qw2Lwhjc2brNAO1aD9VpQPf9RMkv+gEDLoWdLEHw+qpRInDcO1N3kt8bQM= student@PC01"
  loc_my_azure_certified_hw = "azure-byol-voltmesh"
  loc_my_student_number = trimprefix("${var.my_namespace}","student")
  loc_my_subnet_param_ipv4 = "172.31.${local.loc_my_student_number}.0/24"
  loc_my_vnet_name = "${var.my_namespace}-vnet"
  loc_my_vnet_primary_ipv4 = "172.31.0.0/16"
}

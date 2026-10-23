aws_region        = "us-east-1"
instance_type     = "m5.2xlarge"
volume_size       = 80
f5xc_api_p12_file = "./XXXXXXX.console.ves.volterra.io.api-creds.p12"
f5xc_api_url      = "https://XXXXXXX.console.ves.volterra.io/api"

students = ["student101"]

existing_network = {
  "student101" = {
    vpc_id             = "vpc-REPLACE_ME"
    slo_subnet_id      = "subnet-REPLACE_ME"
    sli_subnet_id      = "subnet-REPLACE_ME"
    slo_security_group = "sg-REPLACE_ME"
    sli_security_group = "sg-REPLACE_ME"
    slo_eip_allocation = "eipalloc-REPLACE_ME"
  }
}

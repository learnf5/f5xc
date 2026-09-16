aws_region        = "us-east-1"
aws_az            = "us-east-1a"
instance_type     = "m5.2xlarge"
volume_size       = 80
f5xc_api_p12_file = "./xxxxxxx.console.ves.volterra.io.api-creds.p12"
f5xc_api_url      = "https://xxxxxxx.console.ves.volterra.io/api"

students = {
  "student201" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.201.0/24"
    sli_subnet_cidr = "172.31.221.0/24"
  }
  "student202" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.202.0/24"
    sli_subnet_cidr = "172.31.222.0/24"
  }
  "student203" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.203.0/24"
    sli_subnet_cidr = "172.31.223.0/24"
  }
  "student204" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.204.0/24"
    sli_subnet_cidr = "172.31.224.0/24"
  }
  "student205" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.205.0/24"
    sli_subnet_cidr = "172.31.225.0/24"
  }
  "student206" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.206.0/24"
    sli_subnet_cidr = "172.31.226.0/24"
  }
  "student207" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.207.0/24"
    sli_subnet_cidr = "172.31.227.0/24"
  }
  "student208" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.208.0/24"
    sli_subnet_cidr = "172.31.228.0/24"
  }
  "student209" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.209.0/24"
    sli_subnet_cidr = "172.31.229.0/24"
  }
  "student210" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.210.0/24"
    sli_subnet_cidr = "172.31.230.0/24"
  }
  "student211" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.211.0/24"
    sli_subnet_cidr = "172.31.231.0/24"
  }
  "student212" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.212.0/24"
    sli_subnet_cidr = "172.31.232.0/24"
  }
  "student213" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.213.0/24"
    sli_subnet_cidr = "172.31.233.0/24"
  }
  "student214" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.214.0/24"
    sli_subnet_cidr = "172.31.234.0/24"
  }
}

aws_region        = "us-east-1"
aws_az            = "us-east-1a"
instance_type     = "m5.2xlarge"
volume_size       = 80
f5xc_api_p12_file = "./xxxxxxx.console.ves.volterra.io.api-creds.p12"
f5xc_api_url      = "https://xxxxxxx.console.ves.volterra.io/api"

students = {
  "student201" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.101.0/24"
    sli_subnet_cidr = "172.31.121.0/24"
  }
  "student202" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.102.0/24"
    sli_subnet_cidr = "172.31.122.0/24"
  }
  "student203" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.103.0/24"
    sli_subnet_cidr = "172.31.123.0/24"
  }
  "student204" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.104.0/24"
    sli_subnet_cidr = "172.31.124.0/24"
  }
  "student205" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.105.0/24"
    sli_subnet_cidr = "172.31.125.0/24"
  }
  "student206" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.106.0/24"
    sli_subnet_cidr = "172.31.126.0/24"
  }
  "student207" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.107.0/24"
    sli_subnet_cidr = "172.31.127.0/24"
  }
  "student208" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.108.0/24"
    sli_subnet_cidr = "172.31.128.0/24"
  }
  "student209" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.109.0/24"
    sli_subnet_cidr = "172.31.129.0/24"
  }
  "student210" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.110.0/24"
    sli_subnet_cidr = "172.31.130.0/24"
  }
  "student211" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.111.0/24"
    sli_subnet_cidr = "172.31.131.0/24"
  }
  "student212" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.112.0/24"
    sli_subnet_cidr = "172.31.132.0/24"
  }
  "student213" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.113.0/24"
    sli_subnet_cidr = "172.31.133.0/24"
  }
  "student214" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.114.0/24"
    sli_subnet_cidr = "172.31.134.0/24"
  }
}

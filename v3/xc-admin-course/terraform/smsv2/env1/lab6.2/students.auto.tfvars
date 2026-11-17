aws_region        = "us-east-1"
instance_type     = "m5.2xlarge"
volume_size       = 80
f5xc_api_p12_file = "./xxxxxxxx.console.ves.volterra.io.api-creds.p12"
f5xc_api_url      = "https://xxxxxxxxx.console.ves.volterra.io/api"

# Existing AWS Network Configuration
vpc_id        = "vpc-REPLACE-ME"
slo_subnet_id = "subnet-REPLACE-ME"
sli_subnet_id = "subnet-REPLACE-ME"

# Set of students to deploy CE instances for
students = ["student201", "student202", "student203"]

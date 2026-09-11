# ============================================================
# Data Sources for AWS and F5 XC
# ============================================================

data "aws_ami" "f5xc_ce" {
  most_recent = true
  owners      = ["self", "aws-marketplace"] # AWS Marketplace account & alias

  filter {
    name   = "name"
    values = ["*f5xc-ce*"]
  }

  filter {

    name   = "virtualization-type"
    values = ["hvm"]
  }
}

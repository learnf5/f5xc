variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "aws_az" {
  description = "Availability Zone"
  type        = string
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "EC2 instance type for CE nodes"
  type        = string
  default     = "m5.2xlarge"
}

variable "ce_ami_id" {
  description = "F5 XC CE AMI ID (Optional override; automatically discovered if null)"
  type        = string
  default     = null
}

variable "volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 80
}

variable "f5xc_api_p12_file" {
  description = "Path to F5 XC API P12 certificate file"
  type        = string
}

variable "f5xc_api_url" {
  description = "F5 XC tenant API URL (e.g., https://tenant.console.ves.volterra.io/api)"
  type        = string
}

variable "f5xc_namespace" {
  description = "F5 XC namespace"
  type        = string
  default     = "system"
}

# UPDATED: site_token removed from the student map — it's now auto-generated
variable "students" {
  description = "Map of student configurations"
  type = map(object({
    vpc_cidr        = string
    slo_subnet_cidr = string
    sli_subnet_cidr = string
  }))
}

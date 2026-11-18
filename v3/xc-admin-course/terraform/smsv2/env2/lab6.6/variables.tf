variable "f5xc_api_p12_file" {
  description = "Path to XC API P12 certificate file"
  type        = string
}

variable "f5xc_api_url" {
  description = "F5 XC tenant API URL"
  type        = string
}

variable "my_namespace" {
  description = "XC instructor namespace"
  type        = string
}

variable "my_ce" {
  description = "XC SMSv2 CE"
  type        = string
}

variable "my_xc_domain" {
  description = "XC DNS Domain"
  type        = string
}

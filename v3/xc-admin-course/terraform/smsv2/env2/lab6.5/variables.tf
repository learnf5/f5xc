variable "f5xc_api_p12_file" {
  description = "Path to XC API P12 certificate file"
  type        = string
  default     = "./XXXXXX.console.ves.volterra.io.api-creds.p12"
}

variable "f5xc_api_url" {
  description = "F5 XC tenant API URL"
  type        = string
  default     = "https://XXXXXX.console.ves.volterra.io/api"
}

variable "f5xc_tenant_id" {
  description = "F5 XC tenant ID"
  type        = string
  default     = "XXXXXX-XXXXXX"
}
variable "my_namespace" {
  description = "XC instructor namespace"
  type        = string
  default     = "instructor"
}

variable "my_pool" {
  description = "XC instructor origin pool"
  type        = string
  default     = "demo-smsv2-ce-aws2-op"
}

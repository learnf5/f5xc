variable "health_check_name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "health_check_threshold" {
  type    = number
  default = 3
}

variable "health_check_interval" {
  type    = number
  default = 15
}

variable "health_check_timeout" {
  type    = number
  default = 3
}

variable "health_check_unhealthy_threshold" {
  type    = number
  default = 1
}

variable "health_check_jitter_percent" {
  type    = number
  default = 30
}

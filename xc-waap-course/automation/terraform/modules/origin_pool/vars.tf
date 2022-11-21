variable "origin_pool_name" {
  type = string
}

variable "loadbalancer_algorithm" {
  type    = string
  default = "ROUND ROBIN"
}

variable "ip_origin_pool_name_port" {
  type = number
}

variable "namespace" {
  type = string
}

variable "site_name" {
  type = string
}

variable "health_check_name" {
  type = string
}

variable "service_name" {
  type = string
}

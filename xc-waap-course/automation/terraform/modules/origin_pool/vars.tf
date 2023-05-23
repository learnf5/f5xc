variable "name" {
  type = string
}

variable "loadbalancer_algorithm" {
  type    = string
  default = "ROUND ROBIN"
}

variable "origin_pool_port" {
  type = number
}

variable "namespace" {
  type = string
}

variable "health_check_name" {
  type = string
}

variable "origin_pool_service_name" {
  type = string
}

variable "origin_pool_virtual_site" {
  type = string
}

variable "name" {
  type = string
}

variable "loadbalancer_algorithm" {
  type    = string
  default = "ROUND ROBIN"
}

variable "origin_pool_ip" {
  type = string
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
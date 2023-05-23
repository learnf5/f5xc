## Global variables
variable "name" {
  type    = string
}

variable "namespace" {
  type    = string
}

## Vars for Health check
variable "health_check_path" {
  type    = string
  default = "/"
}

## Vars for IP Origin Pool
variable "loadbalancer_algorithm" {
  type    = string
  default = "ROUND ROBIN"
}

variable "ip_origin_pool_port" {
  type    = number
  default = 80
}

variable "origin_pool_service_name" {
  type    = string
}

variable "origin_pool_virtual_site" {
  type    = string
}

## Load Balancer
variable "domains" {
}

variable "http_port" {
  default = 80
}

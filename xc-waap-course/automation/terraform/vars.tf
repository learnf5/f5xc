## Global variables
variable "name" {
  type    = string
  default = "xc-class"
}
variable "site_name" {
  type    = string
  default = "gitops-tgw"
}

variable "namespace" {
  type    = string
  default = "p-kuligowski"
}

## Vars for Health check
variable "health_check_name" {
  type    = string
  default = "gitops-health-check-tf"
}

variable "health_check_path" {
  type    = string
  default = "/"
}

## Vars for IP Origin Pool
variable "loadbalancer_algorithm" {
  type    = string
  default = "ROUND ROBIN"
}

variable "ip_origin_pool_name_port" {
  type    = number
  default = 80
}

## Load Balancer
variable "domains" {
  default = "example.gitops.com"
}

variable "http_port" {
  default = 80
}

variable "service_name" {
  default = "example.default"
}

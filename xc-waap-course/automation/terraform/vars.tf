## Global variables
variable "name" {
  type    = string
  default = "xc-class"
}

variable "namespace" {
  type    = string
  default = "student-1"
}

## Vars for Health check
variable "health_check_name" {
  type    = string
  default = "xc-class-health-check-tf"
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

variable "ip_origin_pool_port" {
  type    = number
  default = 80
}
variable "origin_pool_ip" {
  type    = string
  default = "3.141.100.187"
}
## Load Balancer
variable "domains" {
  default = "student1-tf.aws.f5learn.cloud"
}

variable "http_port" {
  default = 80
}
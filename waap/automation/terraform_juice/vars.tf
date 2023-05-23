## Global variables
variable "name" {
  type    = string
  default = "student1"
}

variable "namespace" {
  type    = string
  default = "student1"
}

## Vars for Health check
variable "health_check_name" {
  type    = string
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
  default = 1001
}
variable "origin_pool_ip" {
  type    = string
  default = "23.22.60.254"
}
## Load Balancer
variable "domains" {
  default = "student1-tf.aws.learnf5.cloud"
}

variable "http_port" {
  default = 80
}

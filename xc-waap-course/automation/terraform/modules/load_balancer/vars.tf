variable "load_balancer_name" {}
variable "namespace" {}
variable "domains" {}
variable "weight" {
  default = 1
}
variable "priority" {
  default = 1
}
variable "http_port" {}
variable "origin_pool" {}

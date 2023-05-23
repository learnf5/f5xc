terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.11.16"
    }
  }
}

resource "volterra_healthcheck" "volterra_health_check" {
  name      = var.name
  namespace = var.namespace

  http_health_check {
    use_origin_server_name = true
    path                   = var.health_check_path
  }
  healthy_threshold   = var.health_check_threshold
  interval            = var.health_check_interval
  timeout             = var.health_check_timeout
  unhealthy_threshold = var.health_check_unhealthy_threshold
  jitter_percent      = var.health_check_jitter_percent
}

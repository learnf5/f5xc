terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.11.8"
    }
  }
}

resource "volterra_origin_pool" "volterra_ip_origin_pool" {
  name                   = var.origin_pool_name
  namespace              = var.namespace
  loadbalancer_algorithm = var.loadbalancer_algorithm
  healthcheck {
    name      = var.health_check_name
    namespace = var.namespace
  }
  origin_servers {
    k8s_service {
      service_name    = var.service_name
      inside_network  = true
      outside_network = false
      site_locator {
        site {
          name      = var.site_name
          namespace = "system"
        }
      }
    }
  }
  port               = var.ip_origin_pool_name_port
  no_tls             = true
  endpoint_selection = "LOCAL_PREFERRED"
}

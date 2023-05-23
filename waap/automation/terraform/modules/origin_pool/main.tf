terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.11.16"
    }
  }
}

resource "volterra_origin_pool" "volterra_ip_origin_pool" {
  name                   = var.name
  namespace              = var.namespace
  loadbalancer_algorithm = var.loadbalancer_algorithm
  healthcheck {
    name      = var.health_check_name
    namespace = var.namespace
  }
  origin_servers {
    k8s_service {
      service_name = var.origin_pool_service_name
      site_locator {
        virtual_site {
          name      = var.origin_pool_virtual_site
          namespace = "shared"
        }
      }
}
}
     port               = var.origin_pool_port
      no_tls             = true
      endpoint_selection = "LOCAL_PREFERRED"
    }
 

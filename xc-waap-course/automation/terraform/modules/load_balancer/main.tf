terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.11.8"
    }
  }
}

resource "volterra_http_loadbalancer" "load_balancer" {
  lifecycle {
    ignore_changes = [labels]
  }
  name      = var.load_balancer_name
  namespace = var.namespace
  domains   = [var.domains]
  routes {
    simple_route {
      http_method = "ANY"
      path {
        prefix = "/"
      }
      origin_pools {
        pool {
          name = var.origin_pool
        }
      }
      headers {
        name         = "host"
        exact        = "header.example.com"
        invert_match = false
      }
    }
  }
    default_route_pools {
      pool {
        name      = var.origin_pool
        namespace = var.namespace
      }
      weight   = var.weight
      priority = var.priority
    }
    http {
      port = var.http_port
    }
    no_challenge = true
    round_robin  = true
    http {
      dns_volterra_managed = false
    }
    multi_lb_app                    = true
    disable_rate_limit              = true
    service_policies_from_namespace = true
    disable_bot_defense             = true
    disable_waf                     = true
    user_id_client_ip               = true
  }


# ============================================================
# namespace
# ============================================================

resource "volterra_namespace" "my_namespace" {
 name  = var.my_namespace
}

# ============================================================
# health check origin pool origin server
# ============================================================

resource "volterra_healthcheck" "my_hc" {
  name = "${var.my_healthcheck}"
  namespace = "${var.my_namespace}"

  http_health_check {
      path = "/"
      use_http2 = "false"
      expected_status_codes = ["200"]
    }
  timeout = "3"
  interval = "15"
  unhealthy_threshold = "1"
  healthy_threshold = "3"
}

resource "volterra_origin_pool" "my_pool" {
  name = "${var.my_pool}"
  namespace = "${var.my_namespace}"
  loadbalancer_algorithm = "LB_OVERRIDE"
  endpoint_selection = "LOCAL_PREFERRED"
  port = "80"

  healthcheck {
    name = "${var.my_healthcheck}"
    namespace = "${var.my_namespace}"
  }

  origin_servers {
    private_ip {
      ip = "172.26.61.61"
      site_locator {
       site {
        namespace = "system"
        name = "${var.my_ce}"
       }
     }
     inside_network = "true"
    }
  }
  no_tls = "true"
 depends_on = [
 volterra_namespace.my_namespace
 ]
}

# ============================================================
# load balancer
# ============================================================

resource "volterra_http_loadbalancer" "my_loadbalancer" {
  name = "${var.my_loadbalancer}"
  namespace = "${var.my_namespace}"

  domains = ["${var.my_domain}"]
  https_auto_cert {
   http_redirect = "true"
   add_hsts = "true"
   tls_config {
    default_security = "true"
   }
  }

  advertise_on_public_default_vip = "true"
  default_route_pools {
        pool {
          namespace = "${var.my_namespace}"
          name = "${var.my_pool}"
        }
        weight = "1"
        priority = "1"
  }

  depends_on = [
  volterra_origin_pool.my_pool
  ]
}

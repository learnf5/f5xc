# ============================================================
# namespace
# ============================================================

resource "volterra_namespace" "my_namespace" {
 name  = var.my_namespace
}

# ============================================================
# origin pool origin server
# ============================================================

resource "volterra_origin_pool" "my_pool" {
  name = "${var.my_pool}"
  namespace = "${var.my_namespace}"
  loadbalancer_algorithm = "LB_OVERRIDE"
  endpoint_selection = "LOCAL_PREFERRED"
  port = "80"

  origin_servers {
    private_ip {
      ip = "172.31.71.71"
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

  domains = ["demo-smsv2-ce-aws2-lbtest.f5training2.cloud"]
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

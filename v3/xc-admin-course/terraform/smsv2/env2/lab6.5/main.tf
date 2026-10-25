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
        tenant = "${var.f5xc_tenant_id}"
        namespace = "system"
        name = "demo-smsv2-ce-aws2"
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

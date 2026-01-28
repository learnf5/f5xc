resource "volterra_namespace" "my_namespace" {
  name  = var.my_namespace
}

resource "volterra_known_label_key" "my_known_label_key" {
  key         = "${local.loc_namespace}-key"
  namespace   = "shared"
  description = "${var.my_namespace} known label key"
}

resource "volterra_known_label" "my_known_label" {
  key         = "${local.loc_namespace}-key"
  value       = "${var.my_namespace}-key-value"
  namespace   = "shared"
  description = "${var.my_namespace} known label"
  depends_on = [volterra_known_label_key.my_known_label_key]
}

resource "volterra_virtual_site" "my_virtual_site" {
  name      = "${var.my_namespace}-vsite"
  namespace = "shared"
  site_selector {
    expressions = ["${var.my_namespace}-key in (${var.my_namespace}-key-value)"]
  }
  site_type = "CUSTOMER_EDGE"
}
student@pc

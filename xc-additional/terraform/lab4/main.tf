resource "volterra_namespace" "my_namespace" {
  name  = var.my_namespace
}

resource "volterra_known_label_key" "my_known_label_key" {
  key         = "${var.my_known_label_key}"
  namespace   = "shared"
  description = "my known label key"
}

resource "volterra_known_label" "my_known_label" {
  key         = "${var.my_known_label_key}"
  value       = "${var.my_known_label}"
  namespace   = "shared"
  description = "my known label"
  depends_on = [volterra_known_label_key.my_known_label_key]
}

resource "volterra_virtual_site" "my_virtual_site" {
  name      = "${var.my_virtual_site}"
  namespace = "shared"
  site_selector {
    expressions = ["student114-key in (student114-key-value)"]
  }
  site_type = "CUSTOMER_EDGE"
}

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

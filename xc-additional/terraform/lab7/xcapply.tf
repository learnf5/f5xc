resource "volterra_tf_params_action" "my_volterra_tf_params_actions" {
  site_name       = "${local.loc_my_vnet_name}"
  site_kind       = "azure_vnet_site"
  action          = "apply"
}

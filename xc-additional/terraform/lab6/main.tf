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

resource "volterra_azure_vnet_site" "my_azure_vnet_site" {
  name      = "${local.loc_namespace}-vnet"
  namespace = "system"
  labels = {
    "${local.loc_namespace}-key" = "${local.loc_namespace}-value"
  }
  default_blocked_services = true
    azure_cred {
      name      = "creds-azr1211gst01"
      namespace = "system"
      tenant    = "training1-rcfjmagj"
  }
  logs_streaming_disabled = true
  machine_type = "${local.loc_my_machine}"
  azure_region = "${local.loc_my_region}"
  resource_group = "${local.loc_my_resource_group}"
  ingress_gw {
    accelerated_networking {
      disable = true
    }
    az_nodes {
      azure_az = "1"
      local_subnet {
        subnet_param {
          ipv4 = "${local.loc_my_subnet_param_ipv4}"
          ipv6 = ""
        }
      }
    }
    azure_certified_hw = "${local.loc_my_azure_certified_hw}"
    performance_enhancement_mode {
      perf_mode_l7_enhanced = true
    }
  }
  ssh_key = "${local.loc_my_ssh_key}"
  vnet {
    new_vnet {
      name = "${local.loc_my_vnet_name}"
      primary_ipv4 = "${local.loc_my_vnet_primary_ipv4}"
    }
  }
  no_worker_nodes = true
}

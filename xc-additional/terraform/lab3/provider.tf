terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.11.46"
    }
  }
}

provider "volterra" {
  timeout      = "90s"
  api_p12_file = "./training1.console.ves.volterra.io.api-creds.p12"
  url          = "https://training1.console.ves.volterra.io/api"
}

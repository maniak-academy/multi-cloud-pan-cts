terraform {
  required_providers {
    panos = {
      source = "PaloAltoNetworks/panos"
      version = "1.10.3"
    }
  }
}

data "terraform_remote_state" "environment" {
  backend = "local"

  config = {
    path = "../01-deploy-infra/terraform.tfstate"
  }
}

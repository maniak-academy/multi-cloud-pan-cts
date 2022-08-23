
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

module "pan-os" {
  source           = "./pan-os"
  resource_group_name = data.terraform_remote_state.environment.outputs.azurerm_resource_group
  location = data.terraform_remote_state.environment.outputs.location
  owner = data.terraform_remote_state.environment.outputs.owner
  public_subnet  =  module.network.secure_network_subnets[0]
  private_subnet =  module.network.secure_network_subnets[1]
  securemgmt_subnet      = module.network.secure_network_subnets[2]
  depends_on = [
    azurerm_resource_group.consulnetworkautomation
  ]
}
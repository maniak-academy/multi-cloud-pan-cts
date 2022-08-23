

module "pan-os" {
  source           = "./pan-os"
  resource_group_name = var.resource_group_name
  location = var.location
  owner = var.owner
  public_subnet  =  module.network.secure_network_subnets[0]
  private_subnet =  module.network.secure_network_subnets[1]
  securemgmt_subnet      = module.network.secure_network_subnets[2]
  depends_on = [
    azurerm_resource_group.consulnetworkautomation
  ]
}
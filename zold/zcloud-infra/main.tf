

resource "azurerm_resource_group" "consulnetworkautomation" {
  name     = var.resource_group_name
  location = var.location
}

module "azure-network" {
  source              = "./azure-network"
  resource_group_name = var.resource_group_name
  location            = var.location
  owner               = var.owner
  depends_on = [
    azurerm_resource_group.consulnetworkautomation
  ]
}

module "aws-network" {
  source              = "./aws-network"
  resource_group_name = var.resource_group_name
  location            = var.location
  owner               = var.owner
  environment         = var.environment
  region              = var.region
}

module "sharedservices" {
  source              = "./sharedservices"
  resource_group_name = var.resource_group_name
  location            = var.location
  owner               = var.owner
  mgmt_subnet     = module.azure-network.mgmt_subnet
  depends_on = [
    azurerm_resource_group.consulnetworkautomation
  ]
}
  
module "azure-panos" {
  source = "./azure-panos"
  resource_group_name = var.resource_group_name
  location            = var.location
  owner               = var.owner
  mgmt_subnet     = module.azure-network.mgmt_subnet
  private_subnet  = module.azure-network.private_subnet
  public_subnet   = module.azure-network.public_subnets
  depends_on = [
    azurerm_resource_group.consulnetworkautomation
  ]
}
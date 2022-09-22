

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

module "sharedservices" {
  source              = "./sharedservices"
  resource_group_name = var.resource_group_name
  location            = var.location
  owner               = var.owner
  sharedmgmt_subnet    = module.azure-network.sharedmgmt_subnet
  depends_on = [
    azurerm_resource_group.consulnetworkautomation
  ]
}

module "loadbalancer" {
  source = "./loadbalancer"
  resource_group_name = var.resource_group_name
  location = var.location
  owner = var.owner
  web_subnet     = module.azure-network.web_subnet
  app_subnet     = module.azure-network.app_subnet
  db_subnet     = module.azure-network.db_subnet
  depends_on = [
    azurerm_resource_group.consulnetworkautomation
  ]
}

module "routing" {
  source = "./routing"
  resource_group_name = var.resource_group_name
  location = var.location
  owner = var.owner
  web_subnet     = module.azure-network.web_subnet
  app_subnet     = module.azure-network.app_subnet
  db_subnet     = module.azure-network.db_subnet
  sharedmgmt_subnet = module.azure-network.sharedmgmt_subnet
  depends_on = [
    azurerm_resource_group.consulnetworkautomation
  ]
}

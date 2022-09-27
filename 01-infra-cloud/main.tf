

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
  location            = var.location
  owner               = var.owner
}


module "sharedservices" {
  source              = "./sharedservices"
  resource_group_name = var.resource_group_name
  location            = var.location
  owner               = var.owner
  mgmt_subnet   = module.azure-network.mgmt_subnet
  aws_subnet     = module.aws-network.public_subnet
  vpc_id = module.aws-network.vpc_id
  depends_on = [
    azurerm_resource_group.consulnetworkautomation
  ]
}


module "loadbalancer" {
  source              = "./loadbalancer"
  resource_group_name = var.resource_group_name
  location            = var.location
  owner               = var.owner
  web_subnet          = module.azure-network.web_subnet
  app_subnet          = module.azure-network.app_subnet
  db_subnet           = module.azure-network.db_subnet
  depends_on = [
    azurerm_resource_group.consulnetworkautomation
  ]
 }

module "routing" {
  source              = "./routing"
  resource_group_name = var.resource_group_name
  location            = var.location
  owner               = var.owner
  web_subnet          = module.azure-network.web_subnet
  app_subnet          = module.azure-network.app_subnet
  db_subnet           = module.azure-network.db_subnet
  depends_on = [
    azurerm_resource_group.consulnetworkautomation
  ]
}

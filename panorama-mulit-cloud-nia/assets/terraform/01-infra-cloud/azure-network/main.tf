

module "app-network" {
  source              = "Azure/network/azurerm"
  resource_group_name = var.resource_group_name
  vnet_name           = "app-network"
  address_space       = "10.1.0.0/16"
  subnet_prefixes     = ["10.1.10.0/24","10.1.11.0/24", "10.1.12.0/24", "10.1.2.0/24"]
  subnet_names        = ["WEB", "APP", "DB","Shared"]
  
  tags = {
    owner = var.owner
  }
}

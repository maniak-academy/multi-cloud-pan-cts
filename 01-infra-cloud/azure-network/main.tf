

# module "shared-network" {
#   source              = "Azure/network/azurerm"
#   resource_group_name = var.resource_group_name
#   vnet_name           = "shared-network"
#   address_space       = "10.0.0.0/16"
#   subnet_prefixes     = ["10.0.2.0/24"]
#   subnet_names        = ["SharedMGMT"]
  
#   tags = {
#     owner = var.owner
#   }
# }

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


# # VNET Peering between secure and app vnet
# resource "azurerm_virtual_network_peering" "secureTOapp" {
#   name                      = "secureTOapp"
#   resource_group_name       = var.resource_group_name
#   virtual_network_name      = "secure-network"
#   remote_virtual_network_id = module.app-network.vnet_id
# }

# resource "azurerm_virtual_network_peering" "appTOsecure" {
#   name                      = "appTOsecure"
#   resource_group_name       = var.resource_group_name
#   virtual_network_name      = "app-network"
#   remote_virtual_network_id = module.secure-network.vnet_id
# }

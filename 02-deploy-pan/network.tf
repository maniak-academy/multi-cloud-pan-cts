


# # VNET Peering between shared and secure
# resource "azurerm_virtual_network_peering" "sharedTOsecure" {
#   name                      = "sharedTOsecure"
#   resource_group_name = data.terraform_remote_state.environment.outputs.azurerm_resource_group
#   virtual_network_name      = "shared-network"
#   remote_virtual_network_id = module.vnet.vnet_id
# }

# resource "azurerm_virtual_network_peering" "secureToshared" {
#   name                      = "secureToshared"
#   resource_group_name = data.terraform_remote_state.environment.outputs.azurerm_resource_group
#   virtual_network_name      = var.virtual_network_name
#   remote_virtual_network_id = data.terraform_remote_state.environment.outputs.shared_network
# }

# # VNET Peering between secure and app vnet
# resource "azurerm_virtual_network_peering" "secureTOapp" {
#   name                      = "secureTOapp"
#   resource_group_name = data.terraform_remote_state.environment.outputs.azurerm_resource_group
#   virtual_network_name      = var.virtual_network_name
#   remote_virtual_network_id = data.terraform_remote_state.environment.outputs.app_network
# }

# resource "azurerm_virtual_network_peering" "appTOsecure" {
#   name                      = "appTOsecure"
#   resource_group_name = data.terraform_remote_state.environment.outputs.azurerm_resource_group
#   virtual_network_name      = "app-network"
#   remote_virtual_network_id = module.vnet.vnet_id
# }

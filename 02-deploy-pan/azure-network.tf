

#VNET Peering between secure and app vnet
resource "azurerm_virtual_network_peering" "secureTOapp" {
  name                      = "secureTOapp"
  resource_group_name       = data.terraform_remote_state.environment.outputs.azurerm_resource_group
  virtual_network_name      = "securevnet"
  remote_virtual_network_id = data.terraform_remote_state.environment.outputs.app_network
  depends_on = [
    module.vnet
  ]
}

resource "azurerm_virtual_network_peering" "appTOsecure" {
  name                      = "appTOsecure"
  resource_group_name       = data.terraform_remote_state.environment.outputs.azurerm_resource_group
  virtual_network_name      = "app-network"
  remote_virtual_network_id = module.vnet.virtual_network_id
  depends_on = [
    module.vnet
  ]
}

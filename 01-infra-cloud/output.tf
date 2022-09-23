output "azurerm_resource_group" {
  value = var.resource_group_name
}
output "location" {
  value = var.location
}
output "owner" {
  value = var.owner
}
output "bastion-ip" {
  value = "ssh -i bastion.pem azureuser@${module.sharedservices.bastion_ip}"
}
output "vaultlb" {
  value = "http://${module.sharedservices.vault_lb}"
}
output "consullb" {
  value = "http://${module.sharedservices.consul_lb}"
}
output "vault-ip" {
  value = module.sharedservices.vault_ip
}
output "consul-ip" {
  value = module.sharedservices.consul_ip
}
output "consul-public-ip" {
  value = module.sharedservices.consul_public_ip
}
output "vault-public-ip" {
  value = module.sharedservices.vault_public_ip
}
output "app_network" {
  value = module.azure-network.app_network
}
output "web-lb" {
  value = module.loadbalancer.web-lb
}
output "app-lb" {
  value = module.loadbalancer.app-lb
}
output "db-lb" {
  value = module.loadbalancer.db-lb
}
output "app_network_app_subnet" {
  value = module.azure-network.app_subnet
}
output "app_network_db_subnet" {
  value = module.azure-network.db_subnet
}
output "app_network_web_subnet" {
  value = module.azure-network.web_subnet
}
output "app_network_mgmt_subnet" {
  value = module.azure-network.mgmt_subnet
}
output "web-id" {
  value = module.loadbalancer.web-id
}
output "app-id" {
  value = module.loadbalancer.app-id
}
output "db-id" {
  value = module.loadbalancer.db-id
}
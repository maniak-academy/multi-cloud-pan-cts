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
output "vault-lb" {
  value = "http://${module.sharedservices.vault_lb}"
}
output "consul-lb" {
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
output "FirewallIPURL" {
  value = module.azure-panos.FirewallIPURL
}
output "pa_password" {
  value = module.azure-panos.pa_password
  sensitive = true
}
  

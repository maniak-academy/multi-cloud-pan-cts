output "vault_lb" {
  value = azurerm_public_ip.vault.ip_address
}

output "vault_ip" {
  value = azurerm_network_interface.vault.private_ip_address
}

output "bastion_ip" {
  value = azurerm_public_ip.bastion.ip_address
}

output "consul_lb" {
  value = azurerm_public_ip.consul.ip_address
}
output "consul_ip" {
  value = azurerm_network_interface.consul.private_ip_address
}
output "consul_public_ip" {
  value = azurerm_public_ip.consul.ip_address
}
  
output "vault_public_ip" {
  value = azurerm_public_ip.vault.ip_address
}
output "aws_consul_public_url" {
  value = aws_lb.consul.dns_name
}
output "aws_consul_private_ip" {
  value = aws_instance.aws-consul.private_ip
}
output "azure_consul_public_url" {
  value = azurerm_public_ip.consul.fqdn
}
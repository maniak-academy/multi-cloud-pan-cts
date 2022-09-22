
output "pa_username" {
  value = var.adminUsername
}

output "pa_password" {
  value = random_password.pafwpassword.result
}

output "FirewallIPURL" {
  value = "https://${azurerm_public_ip.PublicIP_0.ip_address}"
}
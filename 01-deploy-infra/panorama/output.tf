output "panorama_username" {
  value = var.panorama_username
}

output "panorama_password" {
  value = random_password.panoramapassword.result
}

output "panorama_ip" {
  value = azurerm_public_ip.panorama_public_ip.ip_address
}
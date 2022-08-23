output "pano_username" {
  value = var.pano_username
}

output "pano_password" {
  value = random_password.panopass.result
}

output "pano_ip" {
  value = azurerm_public_ip.pano_public_ip.ip_address
}
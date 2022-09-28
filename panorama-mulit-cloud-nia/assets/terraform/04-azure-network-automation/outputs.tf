output "vault" {
    value = data.terraform_remote_state.environment.outputs.vaultlb
}
output "consul" {
    value = data.terraform_remote_state.environment.outputs.consullb
}
output "panorama-ip" {
  value =  "https://20.118.98.21"
}

# output "WebFQDN" {
#   value = "${data.terraform_remote_state.environment.outputs.WebFQDN}/ui"
# }

output "cts_ip" {
  value = "ssh -i cts.pem azureuser@${azurerm_public_ip.cts.ip_address}"
}  
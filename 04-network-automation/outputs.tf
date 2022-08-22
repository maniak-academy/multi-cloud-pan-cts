output "vault" {
    value = data.terraform_remote_state.environment.outputs.vault_lb
}
output "consul" {
    value = data.terraform_remote_state.environment.outputs.consul_lb
}
output "paloalto_mgmt_ip" {
  value =  data.terraform_remote_state.environment.outputs.https_paloalto_mgmt_ip
}

output "WebFQDN" {
  value = "${data.terraform_remote_state.environment.outputs.WebFQDN}/ui"
}

output "cts_ip" {
  value = "ssh -i cts.pem azureuser@${azurerm_public_ip.cts.ip_address}"
}  
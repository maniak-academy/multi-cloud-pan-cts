
output "vmseries" {
    sensitive = true
    value = module.vmseries
}
output "vault" {
    value = data.terraform_remote_state.environment.outputs.vaultlb
}


# output "consul" {
#     value = data.terraform_remote_state.environment.outputs.consullb
# }

# output "username" {
#     value = module.vmseries.username
# }
# output "password" {
#     value = module.vmseries.password
# }

# output "vmseriesmgmtip" {
#     value = module.vmseries.vmseries_mgmt_ip
# }

output "pan-mgmt-public" {
    value = "https://${module.vmseries.mgmt_ip_address}"
}

output "a-Vault-Credentials" {
    value = "To log into vault the token/password = root"
}
  
output "b-Message" {
    value = "To Bootstrap the PAN-OS does take up to 7 min .. go grab a coffee"
}
  
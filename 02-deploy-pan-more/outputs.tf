
# # output "vmseries" {
# #   sensitive = true
# #   value     = module.vmseries
# # }



# # output "password" {
# #     value = module.vmseries.password
# # }

# # output "vmseriesmgmtip" {
# #     value = module.vmseries.vmseries_mgmt_ip
# # }

# # output "pan-aws-mgmt-public" {
# #   value = "https://${module.awsvmseries.mgmt_ip_address}"
# # }



# output "a-Vault-Credentials" {
#   value = "To log into vault the token/password = root"
# }

# output "b-Message" {
#   value = "To Bootstrap the PAN-OS does take up to 7 min .. go grab a coffee"
# }
# output "c-vault-mangement-ip" {
#   value = data.terraform_remote_state.environment.outputs.vaultlb
# }

# output "d-consul-mangement-ip" {
#   value = data.terraform_remote_state.environment.outputs.consullb
# }

# output "e-pan-azure-mgmt-public" {
#   value = "https://${module.vmseries.mgmt_ip_address}"
# }
# output "pan-azure-mgmt-public" {
#   value = module.vmseries.mgmt_ip_address
# }
# output "f-azure-pan-username" {
#   value = var.username
# }

# output "g-pan-aws-mgmt-public" {
#   description = "Map of public IPs created within the module."
#   value       = { for k, v in module.awsvmseries : k => v.public_ips }
# }
# # output "username" {
# #   value = "globaladmin"
# # }
# # output "password" {
# #   value = "W3lcome098!"
# # }
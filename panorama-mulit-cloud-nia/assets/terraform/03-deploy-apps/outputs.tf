output "azure-consul-public-url" {
  value = data.terraform_remote_state.environment.outputs.azure-consul-public-url
}

output "aws_consul_public_url" {
  value = data.terraform_remote_state.environment.outputs.aws_consul_public_url
}

output "vault_public_ip" {
  value = data.terraform_remote_state.environment.outputs.vaultlb
}

output "Vault-Credentials" {
  value = "To log into vault the token/password = root"
}

output "A-Message" {
  value = "It takes 3-5 mintues to spin up all your servers.. be patient...the cloud is thinking.."
}
output "panorama_ip" {
  value = "https://20.118.98.21"
}

output "pan-azure-mgmt-public" {
  value = data.terraform_remote_state.fw.outputs.e-pan-azure-mgmt-public
}
output "pan-aws-mgmt-public" {
  value = data.terraform_remote_state.fw.outputs.g-pan-aws-mgmt-public
}


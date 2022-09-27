output "vault" {
    value = data.terraform_remote_state.environment.outputs.vaultlb
}
output "consul" {
    value = data.terraform_remote_state.environment.outputs.consullb
}
output "panorama-ip" {
  value =  "https://20.118.98.21"
}

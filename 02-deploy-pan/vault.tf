


provider "vault" {
    address = data.terraform_remote_state.environment.outputs.vaultlb
    token = "root"
}

resource "vault_mount" "infrastructure" {
  path        = "net_infra"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
  depends_on = [
    module.vmseries
  ]
}

resource "vault_kv_secret_v2" "net_infra" {
  mount                      = vault_mount.infrastructure.path
  name                       = "paloalto"
  cas                        = 1
  delete_all_versions        = true
  data_json                  = jsonencode(
  {
    password       =  "${random_password.pafwpassword.result}",
    username       =  "${var.username}"

  }
  )
}




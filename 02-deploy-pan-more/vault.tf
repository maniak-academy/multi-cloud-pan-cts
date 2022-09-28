provider "vault" {
  address = data.terraform_remote_state.environment.outputs.vaultlb
  token   = "root"
}

resource "vault_mount" "infrastructure" {
  path        = "net_infra"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
  depends_on = [
    module.common_vmseries
  ]
}

resource "vault_kv_secret_v2" "azurenet_infra" {
  mount               = vault_mount.infrastructure.path
  name                = "azure-paloalto"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = coalesce(var.password, random_password.this.result),
      username = "${var.username}"

    }
  )
}



resource "vault_kv_secret_v2" "awsnet_infra" {
  mount               = vault_mount.infrastructure.path
  name                = "aws-paloalto"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "W3lcome098!",
      username = "globaladmin"

    }
  )
}



data "terraform_remote_state" "environment" {
  backend = "local"

  config = {
    path = "../01-infra-cloud/terraform.tfstate"
  }
}

resource "random_id" "pansuffix" {
  byte_length = 3
}

resource "random_integer" "password-length" {
  min = 12
  max = 25
}

resource "random_password" "pafwpassword" {
  length           = random_integer.password-length.result
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  special          = true
  override_special = "_%!"
}


# Generate a random password.
resource "random_password" "this" {
  length           = 16
  min_lower        = 16 - 4
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  special          = true
  override_special = "_%@"
}


module "vnet" {
  source  = "PaloAltoNetworks/vmseries-modules/azurerm//modules/vnet"
  version = "0.4.0"

  location                = data.terraform_remote_state.environment.outputs.location
  virtual_network_name    = var.virtual_network_name
  resource_group_name     = data.terraform_remote_state.environment.outputs.azurerm_resource_group
  address_space           = var.address_space
  network_security_groups = var.network_security_groups
  route_tables            = var.route_tables
  subnets                 = var.subnets
  tags                    = var.tags

}



module "vmseries" {
  source  = "PaloAltoNetworks/vmseries-modules/azurerm//modules/vmseries"
  version = "0.4.0"

  location            = data.terraform_remote_state.environment.outputs.location
  resource_group_name = data.terraform_remote_state.environment.outputs.azurerm_resource_group
  name                = "myfw${random_id.pansuffix.dec}"
  username            = var.username
  password            = random_password.pafwpassword.result
  img_version         = var.common_vmseries_version
  img_sku             = var.common_vmseries_sku
  interfaces = [
    {
      name             = "myfw-mgmt-interface"
      subnet_id        = lookup(module.vnet.subnet_ids, "subnet-mgmt", null)
      create_public_ip = true
      #enable_backend_pool = false
    },
    {
      name             = "myfw-public"
      subnet_id        = lookup(module.vnet.subnet_ids, "subnet-public", null)
      create_public_ip = true
      #public_ip_address_id = azurerm_public_ip.PublicIP_1.id
      #lb_backend_pool_id   = module.inbound_lb.backend_pool_id
      #enable_backend_pool  = true
    },
    {
      name      = "myfw-private"
      subnet_id = lookup(module.vnet.subnet_ids, "subnet-private", null)
      #lb_backend_pool_id  = module.outbound_lb.backend_pool_id
      #enable_backend_pool = true

      #Optional static private IP
      #private_ip_address = try(each.value.trust_private_ip, null)
    },
  ]

  bootstrap_options = join(";",
    [
      "type=dhcp-client",
      "hostname=azure-${data.terraform_remote_state.environment.outputs.owner}${random_id.pansuffix.dec}",
      "panorama-server=20.118.98.21",
      "tplname=${data.terraform_remote_state.environment.outputs.owner}${var.tplname}",
      "dgname=${data.terraform_remote_state.environment.outputs.owner}${var.dgname}",
      "dns-primary=168.63.129.16",
      "dns-secondary=8.8.8.8",
      "vm-auth-key=481562602104904"
  ])
}

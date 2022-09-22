
data "terraform_remote_state" "environment" {
  backend = "local"

  config = {
    path = "../01-infra-cloud/terraform.tfstate"
  }
}

# module "vault" {
#   source = "./vault"
#   username = var.username
#   password = coalesce(var.password, random_password.this.result)
# }
 
resource "random_id" "pansuffix" {
  byte_length = 3
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

# Create the network required for the topology.
module "vnet" {
  source = "./modules/vnet"

  virtual_network_name    = var.virtual_network_name
  location                = data.terraform_remote_state.environment.outputs.location
  resource_group_name     = data.terraform_remote_state.environment.outputs.azurerm_resource_group
  address_space           = var.address_space
  network_security_groups = var.network_security_groups
  route_tables            = var.route_tables
  subnets                 = var.subnets
  tags                    = var.vnet_tags

}

# Allow inbound access to Management subnet.
resource "azurerm_network_security_rule" "mgmt" {
  name                        = "vmseries-mgmt-allow-inbound"
  resource_group_name         = data.terraform_remote_state.environment.outputs.azurerm_resource_group
  network_security_group_name = "sg-mgmt"
  access                      = "Allow"
  direction                   = "Inbound"
  priority                    = 1000
  protocol                    = "*"
  source_port_range           = "*"
  source_address_prefixes     = var.allow_inbound_mgmt_ips
  destination_address_prefix  = "*"
  destination_port_range      = "*"

  depends_on = [module.vnet]
}

# Create public IPs for the Internet-facing data interfaces so they could talk outbound.
resource "azurerm_public_ip" "public" {
  for_each = var.vmseries

  name                = "${var.name_prefix}${each.key}-public"
  location            = data.terraform_remote_state.environment.outputs.location
  resource_group_name = data.terraform_remote_state.environment.outputs.azurerm_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.enable_zones ? var.avzones : null
}

# The Inbound Load Balancer for handling the traffic from the Internet.
module "inbound_lb" {
  source = "./modules/loadbalancer"

  name                              = var.inbound_lb_name
  location                          = data.terraform_remote_state.environment.outputs.location
  resource_group_name               = data.terraform_remote_state.environment.outputs.azurerm_resource_group
  frontend_ips                      = var.frontend_ips
  enable_zones                      = var.enable_zones
  avzones                           = var.avzones
  network_security_group_name       = "sg-public"
  network_security_allow_source_ips = coalescelist(var.allow_inbound_data_ips, var.allow_inbound_mgmt_ips)
}

# The Outbound Load Balancer for handling the traffic from the private networks.
module "outbound_lb" {
  source = "./modules/loadbalancer"

  name                = var.outbound_lb_name
  location            = data.terraform_remote_state.environment.outputs.location
  resource_group_name = data.terraform_remote_state.environment.outputs.azurerm_resource_group
  enable_zones        = var.enable_zones
  avzones             = var.avzones
  frontend_ips = {
    outbound = {
      subnet_id                     = lookup(module.vnet.subnet_ids, "subnet-private", null)
      private_ip_address_allocation = "Static"
      private_ip_address            = var.olb_private_ip
      zones                         = var.enable_zones ? var.avzones : null # For the regions without AZ support.
      rules = {
        HA_PORTS = {
          port     = 0
          protocol = "All"
        }
      }
    }
  }
}

# The storage account for VM-Series initialization.
module "bootstrap" {
  source = "./modules/bootstrap"

  location             = data.terraform_remote_state.environment.outputs.location
  resource_group_name  = data.terraform_remote_state.environment.outputs.azurerm_resource_group
  storage_account_name = "panstgfw${random_id.pansuffix.dec}"
  storage_share_name   = var.storage_share_name
  files                = var.files
}

# Common VM-Series for handling:
#   - inbound traffic from the Internet
#   - outbound traffic to the Internet
#   - internal traffic (also known as "east-west" traffic)
module "common_vmseries" {
  source = "./modules/vmseries"

  for_each = var.vmseries

  location            = data.terraform_remote_state.environment.outputs.location
  resource_group_name = data.terraform_remote_state.environment.outputs.azurerm_resource_group
  name                = "${var.name_prefix}${each.key}"
  avzone              = try(each.value.avzone, 1)
  username            = var.username
  password            = coalesce(var.password, random_password.this.result)
  img_version         = var.common_vmseries_version
  img_sku             = var.common_vmseries_sku
  vm_size             = var.common_vmseries_vm_size
  tags                = var.common_vmseries_tags
  enable_zones        = var.enable_zones
  bootstrap_options = "type=dhcp-client;hostname=palo1;panorama-server=20.118.98.21;tplname=pantemplate;dgname=my-device-group;dns-primary=168.63.129.16;dns-secondary=8.8.8.8;vm-auth-key=353532767351718"
  
  # join(",",
  #   [
  #     "storage-account=${module.bootstrap.storage_account.name}",
  #     "access-key=${module.bootstrap.storage_account.primary_access_key}",
  #     "file-share=${module.bootstrap.storage_share.name}",
  #     "share-directory=None"
  # ])
  interfaces = [
    {
      name                = "${each.key}-mgmt"
      subnet_id           = lookup(module.vnet.subnet_ids, "subnet-mgmt", null)
      create_public_ip    = true
      enable_backend_pool = false
    },
    {
      name                 = "${each.key}-public"
      subnet_id            = lookup(module.vnet.subnet_ids, "subnet-public", null)
      public_ip_address_id = azurerm_public_ip.public[each.key].id
      lb_backend_pool_id   = module.inbound_lb.backend_pool_id
      enable_backend_pool  = true
    },
    {
      name                = "${each.key}-private"
      subnet_id           = lookup(module.vnet.subnet_ids, "subnet-private", null)
      lb_backend_pool_id  = module.outbound_lb.backend_pool_id
      enable_backend_pool = true

      # Optional static private IP
      private_ip_address = try(each.value.trust_private_ip, null)
    },
  ]

  diagnostics_storage_uri = module.bootstrap.storage_account.primary_blob_endpoint

  depends_on = [module.bootstrap]
}

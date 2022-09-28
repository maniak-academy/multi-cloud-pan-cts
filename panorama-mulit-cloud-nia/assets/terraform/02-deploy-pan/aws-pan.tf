

module "security_vpc" {
  source  = "PaloAltoNetworks/vmseries-modules/aws//modules/vpc"
  version = "0.2.2"

  name                    = var.security_vpc_name
  cidr_block              = var.security_vpc_cidr
  security_groups         = var.security_vpc_security_groups
  create_internet_gateway = true
  enable_dns_hostnames    = true
  enable_dns_support      = true
  instance_tenancy        = "default"
}

module "security_subnet_sets" {
  source  = "PaloAltoNetworks/vmseries-modules/aws//modules/subnet_set"
  version = "0.2.2"

  for_each = toset(distinct([for _, v in var.security_vpc_subnets : v.set]))

  name                = each.key
  vpc_id              = module.security_vpc.id
  has_secondary_cidrs = module.security_vpc.has_secondary_cidrs
  cidrs               = { for k, v in var.security_vpc_subnets : k => v if v.set == each.key }
}



module "awsvmseries" {
  source   = "PaloAltoNetworks/vmseries-modules/aws//modules/vmseries"
  version  = "0.2.2"
  for_each = var.awsvmseries

  name                  = var.name
  ssh_key_name          = aws_key_pair.demo.key_name
  vmseries_version      = var.vmseries_version
  vmseries_product_code = "e9yfvyj3uag5uo5j2hjikv74n"

  interfaces = {
    for k, v in each.value.interfaces : k => {
      device_index       = v.device_index
      security_group_ids = try([module.security_vpc.security_group_ids[v.security_group]], [])
      source_dest_check  = v.source_dest_check
      subnet_id          = module.security_subnet_sets[v.subnet].subnets[each.value.az].id
      create_public_ip   = v.create_public_ip
    }
  }


  bootstrap_options = join(";",
    [
      "type=dhcp-client",
      "hostname=aws-${data.terraform_remote_state.environment.outputs.owner}${random_id.pansuffix.dec}",
      "panorama-server=20.118.98.21",
      "tplname=${data.terraform_remote_state.environment.outputs.owner}${var.tplname}",
      "dgname=${data.terraform_remote_state.environment.outputs.owner}${var.dgname}",
      "dns-primary=169.254.169.253",
      "dns-secondary=8.8.8.8",
      "vm-auth-key=481562602104904"
  ])
  tags = var.global_tags
}


locals {
  security_vpc_routes = concat(
    [for cidr in var.security_vpc_routes_outbound_destin_cidrs :
      {
        subnet_key   = "mgmt"
        next_hop_set = module.security_vpc.igw_as_next_hop_set
        to_cidr      = cidr
      }
    ],
  )
}

module "security_vpc_routes" {
  for_each = { for route in local.security_vpc_routes : "${route.subnet_key}_${route.to_cidr}" => route }
  source   = "PaloAltoNetworks/vmseries-modules/aws//modules/vpc_route"
  version  = "0.2.2"

  route_table_ids = module.security_subnet_sets[each.value.subnet_key].unique_route_table_ids
  to_cidr         = each.value.to_cidr
  next_hop_set    = each.value.next_hop_set
}




output "sharedmgmt_subnet" {
  value = module.shared-network.vnet_subnets[0]
}

output "web_subnet" {
  value = module.app-network.vnet_subnets[0]
}

output "app_subnet" {
  value = module.app-network.vnet_subnets[1]
}

output "db_subnet" {
  value = module.app-network.vnet_subnets[2]
}
output "app_network" {
  value = module.app-network.vnet_id
}
output "shared_network" {
  value = module.shared-network.vnet_id
}
  
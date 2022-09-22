

output "public_subnets" {
  value = module.secure-network.vnet_subnets[0]
}

output "mgmt_subnet" {
  value = module.secure-network.vnet_subnets[2]
}

output "private_subnet" {
  value = module.secure-network.vnet_subnets[1]
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

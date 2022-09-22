virtual_network_name = "securevnet"
address_space        = ["10.110.0.0/16"]
#enable_zones         = true
tags = {}

network_security_groups = {
  "sg-mgmt" = {
    location = "East US"
    rules = {
      "AllOutbound" = {
        priority                   = 100
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      "ssh" = {
        priority                   = 200
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      "https" = {
        priority                   = 201
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      "panorama" = {
        priority                   = 202
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3978"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      "userid" = {
        priority                   = 203
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "5007"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
    }
  }
  "sg-private" = {
    location = "East US"
    rules = {
      "AllOutbound" = {
        priority                   = 100
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      "AllowInbound" = {
        priority                   = 200
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
    }
  }
  "sg-public"  = {
    location = "East US"
    rules = {
      "AllOutbound" = {
        priority                   = 100
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      "AllowInbound" = {
        priority                   = 200
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
    }
  }
}


route_tables = {
  private_route_table = {
    routes = {
      default = {
        address_prefix         = "0.0.0.0/0"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.110.0.1"
      }
    }
  }
}

subnets = {
  "subnet-mgmt" = {
    address_prefixes       = ["10.110.255.0/24"]
    network_security_group = "sg-mgmt"
  }
  "subnet-private" = {
    address_prefixes       = ["10.110.0.0/24"]
    network_security_group = "sg-private"
    route_table            = "private_route_table"
  }
  "subnet-public" = {
    address_prefixes       = ["10.110.129.0/24"]
    network_security_group = "sg-public"
  }
}

# frontend_ips = {
#   "frontend01" = {
#     create_public_ip = true
#     rules = {
#       "balancessh" = {
#         protocol = "Tcp"
#         port     = 22
#       }
#     }
#   }
# }

vmseries = {
  "fw00" = { avzone = 1 }
  "fw01" = { avzone = 2 }
}

common_vmseries_version = "10.1.6"
common_vmseries_sku     = "bundle1"


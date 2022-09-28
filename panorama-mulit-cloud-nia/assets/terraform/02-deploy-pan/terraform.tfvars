
### AZURE PAN ###

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
  "sg-public" = {
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




### AWS PAN ###

name   = "vmseries-example"
region = "us-east-2"
global_tags = {
  ManagedBy   = "Terraform"
  Application = "Palo Alto Networks VM-Series NGFW"
}

# VPC
security_vpc_name = "security-vpc-example"
security_vpc_cidr = "10.110.0.0/16"

# Subnets
security_vpc_subnets = {
  # Do not modify value of `set=`, it is an internal identifier referenced by main.tf.
  "10.110.255.0/24" = { az = "us-east-2a", set = "mgmt" },
  "10.110.0.0/24"   = { az = "us-east-2a", set = "trust" },
  "10.110.129.0/24" = { az = "us-east-2a", set = "untrust" }


}

# Security Groups
security_vpc_security_groups = {
  vmseries_mgmt = {
    name = "vmseries_mgmt"
    rules = {
      all_outbound = {
        description = "Permit All traffic outbound"
        type        = "egress", from_port = "0", to_port = "0", protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
      https = {
        description = "Permit HTTPS"
        type        = "ingress", from_port = "443", to_port = "443", protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # TODO: update here
      }
      all = {
        description = "Permit HTTPS"
        type        = "ingress", from_port = "0", to_port = "0", protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # TODO: update here
      }
      ssh = {
        description = "Permit SSH"
        type        = "ingress", from_port = "22", to_port = "22", protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # TODO: update here
      }
      panorama = {
        description = "Permit panorama"
        type        = "ingress", from_port = "3978", to_port = "3978", protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # TODO: update here
      }
      userid = {
        description = "Permit userid"
        type        = "ingress", from_port = "5007", to_port = "5007", protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # TODO: update here
      }
    }
  }
  vmseries_untrust = {
    name = "vmseries_untrust"
    rules = {
      all_outbound = {
        description = "Permit All traffic outbound"
        type        = "egress", from_port = "0", to_port = "0", protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
      any_inbound = {
        description = "Permit inbound"
        type        = "ingress", from_port = "0", to_port = "0", protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"] # TODO: update here
      }
    }
  }
  vmseries_trust = {
    name = "vmseries_trust"
    rules = {
      all_outbound = {
        description = "Permit All traffic outbound"
        type        = "egress", from_port = "0", to_port = "0", protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
      any_inbound = {
        description = "Permit inbound"
        type        = "ingress", from_port = "0", to_port = "0", protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"] # TODO: update here
      }
    }
  }
}

# VM-Series
vmseries_version = "10.1.6"
awsvmseries = {
  vmseries01 = {
    az = "us-east-2a"
    interfaces = {
      mgmt = {
        device_index      = 0
        security_group    = "vmseries_mgmt"
        source_dest_check = true
        subnet            = "mgmt"
        create_public_ip  = true
      }
      trust = {
        device_index      = 1
        security_group    = "vmseries_trust"
        source_dest_check = true
        subnet            = "trust"
        create_public_ip  = false
      }
      untrust = {
        device_index      = 2
        security_group    = "vmseries_untrust"
        source_dest_check = true
        subnet            = "untrust"
        create_public_ip  = false
      }
    }
  }
}

# Routes
security_vpc_routes_outbound_destin_cidrs = ["0.0.0.0/0"]

### GCP PAN ###

# project         = "example"
# gcpregion          = "us-central1"
# gcpname            = "example-vmseries"
# allowed_sources = "<list of IP CIDRs>"
# ssh_keys        = "admin:<public key>"
# vmseries_image  = "vmseries-flex-byol-1020"
# bootstrap_options = {
#   hostname           = "vms01"
#   panorama-server    = "10.1.2.3"
#   plugin-op-commands = "numa-perf-optimize:enable,set-dp-cores:2"
#   type               = "dhcp-client"
# }
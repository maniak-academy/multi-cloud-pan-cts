variable "me" {
  type    = string
  default = "seb"
}


variable "tplname" {
  description = "Template name to use for the VM-Series"
  type        = string
  default     = "stack"
}
variable "awsdgname" {
  description = "Device group name to use for the VM-Series"
  type        = string
  default     = "awsdevicegroup"
}

variable "dgname" {
  description = "Device group name to use for the VM-Series"
  type        = string
  default     = "devicegroup"
}


variable "azuredgname" {
  description = "Device group name to use for the VM-Series"
  type        = string
  default     = "azuredevicegroup"
}

variable "virtual_app_network_name" {
  description = "Name of the virtual network to create"
  type        = string
  default     = "app-network"
}

variable "virtual_network_name" {}
variable "address_space" {}
variable "network_security_groups" {}
variable "route_tables" {}
variable "subnets" {}
variable "tags" {}
variable "vmseries" {}
variable "common_vmseries_version" {}
variable "common_vmseries_sku" {}
variable "username" {
  description = "Username for the VM-Series"
  type        = string
  default     = "panadmin"
}

variable "region" {
  description = "The AWS region to use."
  default     = "us-east-2"
}
variable "name" {}
variable "global_tags" {}
variable "security_vpc_name" {}
variable "security_vpc_cidr" {}
variable "security_vpc_security_groups" {}
variable "security_vpc_subnets" {}
variable "awsvmseries" {}
variable "vmseries_version" {}
variable "security_vpc_routes_outbound_destin_cidrs" {}

### GCP VARIABLES ###

# variable "project" {}
# variable "gcpregion" {}
# variable "gcpname" {}
# variable "allowed_sources" {}
# variable "ssh_keys" {}
# variable "vmseries_image" {}
# variable "bootstrap_options" {}

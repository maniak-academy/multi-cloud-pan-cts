variable "me" {
  type = string
  default = "seb"
}
  

variable "tplname" {
  description = "Template name to use for the VM-Series"
 type        = string
  default     = "stack"
}
variable "dgname" {
  description = "Device group name to use for the VM-Series"
    type        = string
    default     = "devicegroup"
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
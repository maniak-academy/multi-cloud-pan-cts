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
variable "vmseries" {}
variable "vmseries_version" {}
variable "security_vpc_routes_outbound_destin_cidrs" {}

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
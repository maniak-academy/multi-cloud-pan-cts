variable "mgmt_subnet" {

}

variable "FirewallDnsName" {
  default = "pan-fw"
}

variable "WebServerDnsName" {
  default = "pan-web"
}

variable "FromGatewayLogin" {
  default = "0.0.0.0/0"
}

variable "IPAddressPublicNetwork" {
  default = "10.0.0.10"
}
variable "IPAddressPrivatedNetwork" {
  default = "10.0.1.10"
}

variable "IPAddressMgmtNetwork" {
  default = "10.0.2.10"
}
variable "routeTableWeb" {
  default = "Web-to-FW"
}

variable "routeTableDB" {
  default = "DB-to-FW"
}

variable "routeTableTrust" {
  default = "Trust-to-intranetwork"
}

# Note internally there is an assumption
# for the two NSG to have the same name!

variable "fwSku" {
  default = "bundle1"
}

variable "fwOffer" {
  default = "vmseries-flex"
}

variable "fwPublisher" {
  default = "paloaltonetworks"
}

variable "adminUsername" {
  default = "paloalto"
}

variable "web-vm-name" {
  default = "webserver-vm"
}

variable "db-vm-name" {
  default = "database-vm"
}

variable "resource_group_name" {}
variable "location" {}
variable "public_subnet" {}
variable "private_subnet" {}

variable "owner" {
  
}
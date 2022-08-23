
variable "FirewallDnsName" {
  default = "pan-fw"
}

variable "WebServerDnsName" {
  default = "pan-web"
}

variable "resource_group_name" {}
variable "location" {}
variable "owner" {}
variable "consul_subnet" {}
variable "FromGatewayLogin" {
  default = "0.0.0.0/0"
}


# Instance settings
variable "pano_size" {
  description = "Virtual Machine size."
  default     = "Standard_D5_v2"
}

variable "pano_username" {
  description = "Initial administrative username to use for Panorama. Mind the [Azure-imposed restrictions](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/faq#what-are-the-username-requirements-when-creating-a-vm)."
  default     = "panadmin"
  type        = string
}
variable "pano_sku" {
  description = "Panorama SKU."
  default     = "byol"
  type        = string
}

variable "pano_version" {
  description = "Panorama PAN-OS Software version. List published images with `az vm image list -o table --all --publisher paloaltonetworks --offer panorama`"
  default     = "10.0.3"
  type        = string
}

variable "pano_publisher" {
  description = "Panorama Publisher."
  default     = "paloaltonetworks"
  type        = string
}

variable "pano_offer" {
  description = "Panorama offer."
  default     = "panorama"
  type        = string
}
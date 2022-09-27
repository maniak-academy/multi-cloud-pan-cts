variable "panorama_ip" {
  description = "Panorama IP address"
  type        = string
  default     = "20.118.98.21"
}

variable "panorama_username" {
  description = "Panorama username"
  type        = string
  default     = "terraformadmin"
}

variable "panorama_password" {
  description = "Panorama password"
  type        = string
  default     = "W3lcome098!"

}

variable "owner" {
  description = "Owner of the stack"
  type        = string
}
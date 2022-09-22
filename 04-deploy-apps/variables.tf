variable "location" {
  description = "The Azure region to use."
  default     = "East US"
  type        = string
}

variable "owner" {
  description = "Owner"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group to create. If not provided, it will be auto-generated."
  type        = string
}

variable "web_count" {
    default = "1"
}
variable "app_count" {
    default = "1"
}
variable "db_count" {
    default = "1"
}

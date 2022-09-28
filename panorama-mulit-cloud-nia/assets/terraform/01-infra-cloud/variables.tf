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

variable "region" {
  description = "The AWS region to use."
  default     = "us-east-2"
  type        = string
}

variable "environment" {
  description = "The environment name to use."
  default     = "dev"
  type        = string

}
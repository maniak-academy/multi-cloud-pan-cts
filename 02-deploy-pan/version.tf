terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.25.0"
    }
    vault = {
      source = "hashicorp/vault"
      version = "3.7.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "azurerm" {
  features {}
}


provider "aws" {
  region = var.region
}
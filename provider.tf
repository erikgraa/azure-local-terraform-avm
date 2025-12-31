terraform {
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "2.8.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.55.0"
    }
    modtm = {
      source  = "Azure/modtm"
      version = "0.3.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.95.0"
    }
  }
  # use local state
  backend "local" {
  }
}

# Provider for current Azure subscription
provider "azurerm" {
  features {}
}

# Resource Group and Storage Account
resource "azurerm_resource_group" "HelloWorld-Basic" {
  name     = "TF-HelloWorld-rg"
  location = "centralus"
}

resource "azurerm_storage_account" "storeacc" {
  name                      = "lillyintrototfdemosa"
  resource_group_name       = azurerm_resource_group.HelloWorld-Basic.name
  location                  = azurerm_resource_group.HelloWorld-Basic.location
  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  is_hns_enabled            = true 
}
terraform {
  backend "local" {
    
  }
  # backend "azurerm" {
  #   resource_group_name  = "bootstrap"
  #   storage_account_name = "bootstrapsadev"
  #   container_name       = "tfstate"
  #   key                  = "msdoc-aks-demo.tfstate"
  # }
}
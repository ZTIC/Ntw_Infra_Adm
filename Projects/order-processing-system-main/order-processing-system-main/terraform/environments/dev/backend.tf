terraform {
  backend "azurerm" {
    resource_group_name  = "oms-tfstate-rg"
    storage_account_name = "omstfstate"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
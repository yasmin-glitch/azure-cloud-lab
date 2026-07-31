terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-tfstate-lab"
    storage_account_name = "tfstate1599118008"
    container_name       = "tfstate"
    key                  = "hub-spoke.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
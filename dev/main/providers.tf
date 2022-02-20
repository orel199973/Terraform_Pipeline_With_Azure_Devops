terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }
  required_version = ">= 0.14.9"
  backend "azurerm" {
    resource_group_name  = "shtech"
    storage_account_name = "shtechcommon"
    container_name       = "terrafrom-states"
    key                  = format("Terraform/%s.tfstate", var.name)
  }

}

provider "azurerm" {
  features {}
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.28.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rajan"
    storage_account_name = "pipelinestorageaccoun4"
    container_name       = "pipelinecontainer"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  subscription_id = "0cead613-b99d-4057-9b73-e282208bb4c4"
  features {
  }
}
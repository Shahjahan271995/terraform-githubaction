provider "azurerm" {
  subscription_id = "7fd59e8b-ebe2-47cb-9c43-38fb4761eff1"
  features {
  }
}
resource "azurerm_resource_group" "githubrg" {
  name     = "Actionrg"
  location = "east us"
}

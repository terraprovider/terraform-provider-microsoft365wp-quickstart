## Providers and Backend Configuration

terraform {
  required_version = ">= 1.7"
  required_providers {
    microsoft365wp = {
      source  = "terraprovider/microsoft365wp"
      version = "0.14"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.47.0"
    }
  }
  backend "azurerm" {
    storage_account_name = "storageaccountname"
    subscription_id      = "000..."
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
    use_oidc             = true
  }
}

provider "azuread" {
  use_oidc = true
}

provider "microsoft365wp" {
  use_oidc = true
}

terraform {
  required_version = ">= 1.7"
  required_providers {
    microsoft365wp = {
      source  = "terraprovider/microsoft365wp"
      version = "0.15.1"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.1.0"
    }
  }
  backend "azurerm" {
    storage_account_name = "c4a8toydexports01"
    subscription_id      = "3f0a7847-..."
    container_name       = "tfstate"
    key                  = "terraform-qs.tfstate"
    use_azuread_auth     = true
    use_oidc             = true
    snapshot             = true
  }
}

provider "azuread" {
  use_oidc = true
}

provider "microsoft365wp" {
  use_oidc = true
}

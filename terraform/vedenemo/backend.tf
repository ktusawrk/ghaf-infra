# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "azurerm" {
    container_name       = "ghaf-infra-tfstate-container"
    key                  = "vedenemo.tfstate"
    resource_group_name  = "ghaf-infra-0-state-eun"
    storage_account_name = "ghafinfra0stateeun"
  }
}
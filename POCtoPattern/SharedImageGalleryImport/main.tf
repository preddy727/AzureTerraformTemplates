provider "azurerm" {
  version = "~> 1.23"
}

terraform {
  backend "azurerm" {
    storage_account_name  = "${var.storageaccountname}"
    container_name        = "tstate"
    key                   = "terraform.tstate"
  }
}

module "sharedimage" {
  source = "../modules/SharedImageGalleryImport"
}


provider "azurerm" {
  version = "~> 1.23"
}

#terraform {
#  backend "azurerm" {
#    storage_account_name  = "${var.storageaccountname}"
#    container_name        = "tstate"
#    key                   = "terraform.tstate"
#  }
#}

module "test_net" {
  source = "../Modules/VNET"
  location = "${var.location}"
  name_prefix = "${var.name_prefix}"
  environment = "${var.environment}"
  vnet_cidr = "${var.vnet_cidr}"
}

module "vm" {
  source = "../Modules/centoshashicorpvm"
  environment = "${var.environment}"
#  publisher = "${var.publisher}"
#  offer = "$var.offer}"
#  sku = "$var.sku}" 
  name_prefix = "${var.name_prefix}"
  admin_password = "${var.admin_password}"
  hostname = "${var.hostname}"
  subnet_id = "${lookup(module.test_net.default_subnet, "id")}"
}

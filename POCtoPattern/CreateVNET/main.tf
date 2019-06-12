provider "azurerm" {

  version = "~> 1.23"

}

module "test_net" {
  source = "../Modules/VNET"
  location = "${var.location}"
  name_prefix = "${var.name_prefix}"
  environment = "${var.environment}"
  vnet_cidr = "${var.vnet_cidr}"
}


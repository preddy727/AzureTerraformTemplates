provider "azurerm" {
  version = "~> 1.23"
}


module "keyvault" {
  source = "./modules/keyvault"
  location = "${var.location}"
  name_prefix = "${var.name_prefix}"
  environment = "${var.environment}"
  permitted_subnets = "${list(lookup(module.test_net.default_subnet, "id"))}"
}

module "test_net" {
  source = "./modules/vnet"
  location = "${var.location}"
  name_prefix = "${var.name_prefix}"
  environment = "${var.environment}"
  vnet_cidr = "${var.vnet_cidr}"
}

# module "mi" {
#   source = "./modules/keyvault"
# }


# module "sharedimage" {
#   source = "./modules/keyvault"
# }

module "vm" {
  source = "./modules/vm"
  vnet_name = "${lookup(module.test_net.vnet, "id")}"
  network_rg = "${module.test_net.resource_group}"
  name_prefix = "${var.name_prefix}"
  admin_password = "${var.admin_password}"
  hostname = "${var.hostname}"
  subnet_name = "${lookup(module.test_net.default_subnet, "name")}"
}

# module "vmss" {
#   source = "./modules/keyvault"
# }

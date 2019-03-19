provider "azurerm" {
  version = "~> 1.23"
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

#module "vm" {
#  source = "./modules/centoshashicorpvm"
#  name_prefix = "${var.name_prefix}"
#  admin_password = "${var.admin_password}"
#  hostname = "${var.hostname}"
#  subnet_id = "${lookup(module.test_net.default_subnet, "id")}"
#}

module "keyvault" {
  source = "./modules/keyvault"
  location = "${var.location}"
  name_prefix = "${var.name_prefix}"
  environment = "${var.environment}"
  permitted_subnets = "${list(lookup(module.test_net.default_subnet, "id"))}"
}


# module "vmss" {
#   source = "./modules/keyvault"
# }

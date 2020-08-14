# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.20.0"
  features {}
}
module "keyvault" {
  source = "../Modules/keyvault"
  location = "${var.location}"
  objectid = "${var.objectid}"
  objectid2 = "${var.objectid2}" 
  applicationid = "${var.applicationid}"
  ip_rules = "${var.ip_rules}"
  name_prefix = "${var.name_prefix}"
  environment = "${var.environment}"
}



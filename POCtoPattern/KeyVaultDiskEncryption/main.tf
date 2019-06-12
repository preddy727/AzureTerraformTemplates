provider "azurerm" {

  version = "~> 1.25"

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



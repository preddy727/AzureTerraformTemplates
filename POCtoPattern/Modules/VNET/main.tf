resource "azurerm_resource_group" "network" {

  name = "${var.name_prefix}"

  location = "${var.location}"

}



resource "azurerm_virtual_network" "network" {

  name = "${var.name_prefix}"

  address_space = ["${var.vnet_cidr}"]

  location = "${azurerm_resource_group.network.location}"

  resource_group_name = "${azurerm_resource_group.network.name}"

}

/*
resource "azurerm_subnet" "gateway_subnet" {

  name = "GatewaySubnet"

  resource_group_name = "${azurerm_resource_group.network.name}"

  virtual_network_name = "${azurerm_virtual_network.network.name}"

  address_prefix = "${local.gateway_network_cidr}"}



resource "azurerm_subnet" "appgw" {

  name = "${var.name_prefix}-appgw"

  resource_group_name = "${azurerm_resource_group.network.name}"

  virtual_network_name = "${azurerm_virtual_network.network.name}"

  address_prefix = "${local.application_gw_subnet_cidr}"

}
*/

resource "azurerm_subnet" "default" {

  name = "${var.name_prefix}-default"

  resource_group_name = "${azurerm_resource_group.network.name}"

  virtual_network_name = "${azurerm_virtual_network.network.name}"

  address_prefix = "${local.default_subnet_cidr}"

  service_endpoints = "${var.service_endpoints}"

}

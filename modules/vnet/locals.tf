locals {
  gateway_network_cidr = "${cidrsubnet(var.vnet_cidr, 5, 0)}"
  application_gw_subnet_cidr = "${cidrsubnet(var.vnet_cidr, 5, 1)}"

  default_subnet_cidr = "${cidrsubnet(var.vnet_cidr, 2, 2)}"
}

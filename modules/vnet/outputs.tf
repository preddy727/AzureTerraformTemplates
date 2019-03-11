output "resource_group" {
  value = "${azurerm_resource_group.network.id}"
}

output "vnet" {
  value = "${
    map(
      "id", "${azurerm_virtual_network.network.id}",
      "name", "${azurerm_virtual_network.network.name}",
      "location", "${azurerm_virtual_network.network.location}",
      "address_space", "${azurerm_virtual_network.network.address_space}"
    )
  }"
}

output "gateway_subnet" {
  value = "${
    map(
      "id", "${azurerm_subnet.gateway_subnet.id}",
      "ip_configurations", "${azurerm_subnet.gateway_subnet.ip_configurations}",
      "name", "${azurerm_subnet.gateway_subnet.name}",
      "address_prefix", "${azurerm_subnet.gateway_subnet.address_prefix}"
    )
  }"
}

output "appgw_subnet" {
  value = "${
    map(
      "id", "${azurerm_subnet.appgw.id}",
      "ip_configurations", "${azurerm_subnet.appgw.ip_configurations}",
      "name", "${azurerm_subnet.appgw.name}",
      "address_prefix", "${azurerm_subnet.appgw.address_prefix}"
    )
  }"
}
output "default_subnet" {
  value = "${
    map(
      "id", "${azurerm_subnet.default.id}",
      "ip_configurations", "${azurerm_subnet.default.ip_configurations}",
      "name", "${azurerm_subnet.default.name}",
      "address_prefix", "${azurerm_subnet.default.address_prefix}"
    )
  }"
}





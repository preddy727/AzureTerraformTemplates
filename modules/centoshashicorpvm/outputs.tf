output "vm" {
  value = {
    "id" = "${azurerm_virtual_machine.vm.id}"
  }
}

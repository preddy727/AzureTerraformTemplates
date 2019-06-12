data "azurerm_subscription" "subscription" {}



data "azurerm_builtin_role_definition" "builtin_role_definition" {

  name = "Contributor"

}



# Grant the VM identity contributor rights to the current subscription

resource "azurerm_role_assignment" "role_assignment" {

  scope              = "${data.azurerm_subscription.subscription.id}"

  role_definition_id = "${data.azurerm_subscription.subscription.id}${data.azurerm_builtin_role_definition.builtin_role_definition.id}"

  principal_id       = "${lookup(azurerm_virtual_machine.vm.identity[0], "principal_id")}"



  lifecycle {

    ignore_changes = ["name"]

  }

}



resource "azurerm_resource_group" "network" {

  name = "${var.name_prefix}"

  location = "${var.location}"

}



resource "azurerm_network_interface" "nic" {

  name                = "${var.hostname}nic"

  location            = "${var.location}"

  resource_group_name = "${azurerm_resource_group.network.name}"



  ip_configuration {

    name                          = "${var.hostname}ipconfig"

    subnet_id                     = "${var.subnet_id}"

    private_ip_address_allocation = "Dynamic"

    public_ip_address_id          = "${azurerm_public_ip.pip.id}"

  }



}



resource "azurerm_public_ip" "pip" {

  name                          = "${var.hostname}-ip"

  location                      = "${var.location}"

  resource_group_name           = "${azurerm_resource_group.network.name}"

  allocation_method             = "Dynamic"

  domain_name_label             = "${var.hostname}"



}



resource "azurerm_virtual_machine" "vm" {

  name                  = "${var.hostname}"

  location              = "${var.location}"

  resource_group_name   = "${azurerm_resource_group.network.name}"

  vm_size               = "${var.vm_size}"

  network_interface_ids = ["${azurerm_network_interface.nic.id}"]

  identity = {

    type = "SystemAssigned"

  }

  storage_os_disk {

        name              = "osDisk"

        caching           = "ReadWrite"

        create_option     = "FromImage"

        managed_disk_type = "Standard_LRS"

    }



   storage_image_reference {

        publisher = "${var.publisher}"

        offer     = "${var.offer}"

        sku       = "${var.sku}"

        version   = "latest"

    }



  os_profile {

    computer_name  = "${var.hostname}"

    admin_username = "${var.admin_username}"

    admin_password = "${var.admin_password}"

  }



  os_profile_linux_config {

    disable_password_authentication = false

  }

}

resource "azurerm_resource_group" "test" {
  name     = "${var.rgname}"
  location = "${var.location"
}

resource "azurerm_virtual_network" "test" {
  name                = "${var.vnetname}"
  address_space       = ["${var.addrspace}"]
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
}

resource "azurerm_subnet" "test" {
  name                 = "${var.subnetname}"
  resource_group_name  = "${azurerm_resource_group.test.name}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "test" {
  name                = "${var.netintname}"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  ip_configuration {
    name                          = "${var.ipconfigname}"
    subnet_id                     = "${azurerm_subnet.test.id}"
    private_ip_address_allocation = "dynamic"
  }

  tags {
    environment = "staging"
  }
}

#-------------
# VM Configuration
#-------------

resource "azurerm_virtual_machine" "virtual_machine" {
  name                  = "${var.vmname}"
  location              = "${azurerm_resource_group.test.location}"
  resource_group_name   = "${azurerm_resource_group.test.name}"
  network_interface_ids = ["${azurerm_network_interface.test.id}"]
  vm_size               = "${var.vmsize}"

  identity = {
    type = "SystemAssigned"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-smalldisk"
    version   = "latest"
  }

  storage_os_disk {
    name              = "test"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "test"
    admin_username = "username"
    admin_password = "password...123"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = false
  }
}

resource "azurerm_virtual_machine_extension" "virtual_machine_extension" {
  name                 = "test"
  location              = "${azurerm_resource_group.test.location}"
  resource_group_name  = "${azurerm_resource_group.test.name}"
  virtual_machine_name = "${azurerm_virtual_machine.virtual_machine.name}"
  publisher            = "Microsoft.ManagedIdentity"
  type                 = "ManagedIdentityExtensionForWindows"
  type_handler_version = "1.0"

  settings = <<SETTINGS
    {
        "port": 50342
    }
SETTINGS
}

data "azurerm_subscription" "subscription" {}

data "azurerm_builtin_role_definition" "builtin_role_definition" {
  name = "Contributor"
}

# Grant the VM identity contributor rights to the current subscription
resource "azurerm_role_assignment" "role_assignment" {
  scope              = "${data.azurerm_subscription.subscription.id}"
  role_definition_id = "${data.azurerm_subscription.subscription.id}${data.azurerm_builtin_role_definition.builtin_role_definition.id}"
  principal_id       = "${lookup(azurerm_virtual_machine.virtual_machine.identity[0], "principal_id")}"

  lifecycle {
    ignore_changes = ["name"]
  }
}

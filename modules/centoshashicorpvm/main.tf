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
  name = "${var.name_prefix}-vnet"
  location = "${var.location}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.name_prefix}-compute-rg"
  location = "${var.location}"
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.hostname}nic"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

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
  resource_group_name           = "${azurerm_resource_group.rg.name}"
  allocation_method             = "Dynamic"
  domain_name_label             = "${var.hostname}"

}

resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.hostname}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
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

data "azurerm_key_vault" "test" {
  name                = "${var.name_prefix}-vault"
  resource_group_name = "${var.name_prefix}-rg"
}

data "azurerm_key_vault_key" "testsecret" {
  name      = "generated-certificate"
  key_vault_id = "${data.azurerm_key_vault.test.id}"
}


resource "azurerm_virtual_machine_extension" "disk-encryption" {
  name                 = "DiskEncryption"
  location             = "${var.location}"
 resource_group_name = "${azurerm_resource_group.rg.name}"
  virtual_machine_name = "${azurerm_virtual_machine.vm.name}"
  publisher            = "Microsoft.Azure.Security"
  type                 = "AzureDiskEncryptionForLinux"
  type_handler_version = "1.1"

  settings = <<SETTINGS
{
  "EncryptionOperation": "EnableEncryption",
  "KeyVaultURL": "https://${var.name_prefix}-vault.vault.azure.net",
  "KeyVaultResourceId": "${data.azurerm_subscription.subscription.id}/resourceGroups/${var.name_prefix}-rg/providers/Microsoft.KeyVault/vaults/${var.name_prefix}-vault",
  "KeyEncryptionKeyURL": "https://${var.name_prefix}-vault.vault.azure.net/keys/generated-certificate/${data.azurerm_key_vault_key.testsecret.version}",
  "KekVaultResourceId": "${data.azurerm_subscription.subscription.id}/resourceGroups/${var.name_prefix}-rg/providers/Microsoft.KeyVault/vaults/${var.name_prefix}-vault",
  "KeyEncryptionAlgorithm": "RSA-OAEP",
  "VolumeType": "All"
}
SETTINGS
}
 

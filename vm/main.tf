data "azurerm_shared_image_version" "image" {
  name                = "1.0.0"     
  image_name          = "ubuntu_tomcat"
  gallery_name        = "demo"
  resource_group_name = "SharedImageGallery"
}


provider "azurerm" {
  subscription_id = ""
}

#provider "azurerm" {
#  alias  = "b"
#  subscription_id = ""
#}
 
resource "azurerm_resource_group" "rg" {

  name     = "${var.resource_group}"

  location = "${var.location}"

}



resource "azurerm_virtual_network" "vnet" {

  name                = "${var.hostname}vnet"

  location            = "${var.location}"

  address_space       = ["${var.address_space}"]

  resource_group_name = "${azurerm_resource_group.rg.name}"

}

resource "azurerm_key_vault" "test" {
  name                = "testvault"
  location            = "${azurerm_resource_group.testrg.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  sku {
    name = "standard"
  }

  network_rules { 
    ip_rules = ["127.0.0.1"] 
    virtual_network_subnet_ids = ["${azurerm_subnet.test.id}"] 
  }
}


resource "azurerm_subnet" "subnet" {

  name                 = "${var.hostname}subnet"

  virtual_network_name = "${azurerm_virtual_network.vnet.name}"

  resource_group_name  = "${azurerm_resource_group.rg.name}"

  address_prefix       = "${var.subnet_prefix}"
  
  service_endpoints    = ["Microsoft.KeyVault"]

}



resource "azurerm_network_interface" "nic" {

  name                = "${var.hostname}nic"

  location            = "${var.location}"

  resource_group_name = "${azurerm_resource_group.rg.name}"



  ip_configuration {

    name                          = "${var.hostname}ipconfig"

    subnet_id                     = "${azurerm_subnet.subnet.id}"

    private_ip_address_allocation = "Dynamic"

    public_ip_address_id          = "${azurerm_public_ip.pip.id}"

  }

}



resource "azurerm_public_ip" "pip" {

  name                         = "${var.hostname}-ip"

  location                     = "${var.location}"

  resource_group_name          = "${azurerm_resource_group.rg.name}"

  allocation_method = "Dynamic"

  domain_name_label            = "${var.hostname}"

}



resource "azurerm_virtual_machine" "vm" {
  
#  provider = "azurerm.b" 
 
  name                  = "${var.hostname}"

  location              = "${var.location}"

  resource_group_name   = "${azurerm_resource_group.rg.name}"

  vm_size               = "${var.vm_size}"

  network_interface_ids = ["${azurerm_network_interface.nic.id}"]

  storage_os_disk {
        name              = "osDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        id = "${data.azurerm_shared_image_version.image.id}"
    }

  os_profile {

    computer_name  = "${var.hostname}"

    admin_username = "${var.admin_username}"

    admin_password = "${var.admin_password}"

  }



  os_profile_linux_config {

    disable_password_authentication = false

  }
  
  resource "azurerm_virtual_machine_extension" "disk-encryption" {
  name                 = "DiskEncryption"
  location             = "${local.location}"
 resource_group_name = "${azurerm_resource_group.environment-rg.name}"
  virtual_machine_name = "${azurerm_virtual_machine.server.name}"
  publisher            = "Microsoft.Azure.Security"
  type                 = "AzureDiskEncryption"
  type_handler_version = "2.2"

  settings = <<SETTINGS
{
  "EncryptionOperation": "EnableEncryption",
  "KeyVaultURL": "https://${local.vaultname}.vault.azure.net",
  "KeyVaultResourceId": "/subscriptions/${local.subscriptionid}/resourceGroups/${local.vaultresourcegroup}/providers/Microsoft.KeyVault/vaults/${local.vaultname}",
  "KeyEncryptionKeyURL": "https://${local.vaultname}.vault.azure.net/keys/${local.keyname}/${local.keyversion}",
  "KekVaultResourceId": "/subscriptions/${local.subscriptionid}/resourceGroups/${local.vaultresourcegroup}/providers/Microsoft.KeyVault/vaults/${local.vaultname}",
  "KeyEncryptionAlgorithm": "RSA-OAEP",
  "VolumeType": "All"
}
SETTINGS
}

}

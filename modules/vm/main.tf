data "azurerm_shared_image_version" "image" {
  name                = "1.0.0"     
  image_name          = "ubuntu_tomcat"
  gallery_name        = "attdemo"
  resource_group_name = "SharedImageGallery"
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

}

provider "azurerm" {

  version = "~> 1.0"

}



provider "template" {

  version = "~> 1.0"

}



module "os" {

  source       = "./os"

  vm_os_simple = "${var.vm_os_simple}"

}



resource "azurerm_resource_group" "vmss" {

  name     = "${var.resource_group_name}"

  location = "${var.location}"

  tags     = "${var.tags}"

}



data "template_file" "cloudconfig" {

  template = "${file("${var.cloudconfig_file}")}"

}



data "template_cloudinit_config" "config" {

  gzip          = true

  base64_encode = true



  part {

    content_type = "text/cloud-config"

    content      = "${data.template_file.cloudconfig.rendered}"

  }data "azurerm_shared_image_version" "image" {
  name                = "1.0.0"
  image_name          = "ubuntu_tomcat"
  gallery_name        = "attdemo"
  resource_group_name = "SharedImageGallery"
}

resource "azurerm_resource_group" "test" {
  name     = "acctestRG"
  location = "West US 2"
}

resource "azurerm_virtual_network" "test" {
  name                = "acctvn"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
}

resource "azurerm_subnet" "test" {
  name                 = "acctsub"
  resource_group_name  = "${azurerm_resource_group.test.name}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  address_prefix       = "10.0.2.0/24"
  service_endpoints    ="Microsoft.KeyVault" 
}

resource "azurerm_public_ip" "test" {
  name                = "test"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  allocation_method   = "Static"
  domain_name_label   = "${azurerm_resource_group.test.name}"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_lb" "test" {
  name                = "test"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.test.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  resource_group_name = "${azurerm_resource_group.test.name}"
  loadbalancer_id     = "${azurerm_lb.test.id}"
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_nat_pool" "lbnatpool" {
  count                          = 3
  resource_group_name            = "${azurerm_resource_group.test.name}"
  name                           = "ssh"
  loadbalancer_id                = "${azurerm_lb.test.id}"
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_probe" "test" {
  resource_group_name = "${azurerm_resource_group.test.name}"
  loadbalancer_id     = "${azurerm_lb.test.id}"
  name                = "http-probe"
  request_path        = "/health"
  port                = 8080
}

resource "azurerm_virtual_machine_scale_set" "test" {
  name                = "mytestscaleset-1"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  # automatic rolling upgrade
  automatic_os_upgrade = true
  upgrade_policy_mode  = "Rolling"

  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT0S"
  }

  # required when using rolling upgrade policy
  health_probe_id = "${azurerm_lb_probe.test.id}"

  sku {
    name     = "Standard_F2"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

storage_image_reference {
        id = "${data.azurerm_shared_image_version.image.id}"
}
  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix = "testvm"
    admin_username       = "myadmin"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/myadmin/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/demo_key.pub")}"
    }
  }

  network_profile {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "TestIPConfiguration"
      primary                                = true
      subnet_id                              = "${azurerm_subnet.test.id}"
      load_balancer_backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.bpepool.id}"]
      load_balancer_inbound_nat_rules_ids    = ["${element(azurerm_lb_nat_pool.lbnatpool.*.id, count.index)}"]
    }
  }

  tags = {
    environment = "staging"
  }
}


}



resource "azurerm_virtual_machine_scale_set" "vm-linux" {

  count               = "${var.nb_instance}"

  name                = "${var.vmscaleset_name}"

  location            = "${var.location}"

  resource_group_name = "${azurerm_resource_group.vmss.name}"

  upgrade_policy_mode = "Manual"

  tags                = "${var.tags}"



  sku {

    name     = "${var.vm_size}"

    tier     = "Standard"

    capacity = "${var.nb_instance}"

  }



  storage_profile_image_reference {

    id        = "${var.vm_os_id}"

    publisher = "${coalesce(var.vm_os_publisher, module.os.calculated_value_os_publisher)}"

    offer     = "${coalesce(var.vm_os_offer, module.os.calculated_value_os_offer)}"

    sku       = "${coalesce(var.vm_os_sku, module.os.calculated_value_os_sku)}"

    version   = "${var.vm_os_version}"

  }



  storage_profile_os_disk {

    name              = ""

    caching           = "ReadWrite"

    create_option     = "FromImage"

    managed_disk_type = "${var.managed_disk_type}"

  }



  storage_profile_data_disk {

    lun           = 0

    caching       = "ReadWrite"

    create_option = "Empty"

    disk_size_gb  = "${var.data_disk_size}"

  }



  os_profile {

    computer_name_prefix = "${var.computer_name_prefix}"

    admin_username       = "${var.admin_username}"

    admin_password       = "${var.admin_password}"

    custom_data          = "${data.template_cloudinit_config.config.rendered}"

  }



  os_profile_linux_config {

    disable_password_authentication = true



    ssh_keys {

      path     = "/home/${var.admin_username}/.ssh/authorized_keys"

      key_data = "${file("${var.ssh_key}")}"

    }

  }



  network_profile {

    name    = "${var.network_profile}"

    primary = true



    ip_configuration {

      name                                   = "IPConfiguration"

      subnet_id                              = "${var.vnet_subnet_id}"

      load_balancer_backend_address_pool_ids = ["${var.load_balancer_backend_address_pool_ids}"]

    }

  }

}

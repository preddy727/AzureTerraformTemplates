provider "azurerm" {
  version = "~> 1.23"
}
module "network" {
  source              = "Azure/network/azurerm"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}

module "loadbalancer" {
  source              = "Azure/loadbalancer/azurerm"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  prefix              = "terraform-test"

  "remote_port" {
    ssh = ["Tcp", "22"]
  }

  "lb_port" {
    http = ["8080", "Tcp", "8080"]
  }
}

module "vmss-cloudinit" {
  source                                 = "..//Modules/VMSS"
  resource_group_name                    = "${var.resource_group_name}"
  name_prefix                            = "${var.name_prefix}"
  keyvaultname                           = "${var.keyvaultname}"
  cloudconfig_file                       = "${path.module}/cloudconfig.tpl"
  location                               = "${var.location}"
  vm_size                                = "${var.vm_size}"
  admin_username                         = "${var.admin_username}"
  admin_password                         = "${var.admin_password}"
#  ssh_key                                = "~/.ssh/id_rsa.pub"
  nb_instance                            = "${var.nb_instance}"
  shared_image_gallery_name              = "${var.shared_image_gallery_name}" 
  shared_image_resource_group            = "${var.shared_image_resource_group}"
  shared_image_version                   = "${var.shared_image_version}"
  shared_image_name                      = "${var.shared_image_name}"
 # vm_os_simple                           = "CentOS"
  vnet_subnet_id                         = "${module.network.vnet_subnets[0]}"
  load_balancer_backend_address_pool_ids = "${module.loadbalancer.azurerm_lb_backend_address_pool_id}"
}

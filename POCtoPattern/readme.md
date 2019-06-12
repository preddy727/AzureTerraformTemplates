#Usage
provider "azurerm" {
  version = "~> 1.0"
}

variable "resource_group_name" {
  default = "terraform-vmss-cloudinit"
}

variable "location" {
  default = "eastus"
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
    http = ["80", "Tcp", "80"]
  }
}

module "vmss-cloudinit" {
  source                                 = "Azure/vmss-cloudinit/azurerm"
  resource_group_name                    = "${var.resource_group_name}"
  cloudconfig_file                       = "${path.module}/cloudconfig.tpl"
  location                               = "${var.location}"
  vm_size                                = "Standard_DS2_v2"
  admin_username                         = "azureuser"
  admin_password                         = "ComplexPassword"
  ssh_key                                = "~/.ssh/id_rsa.pub"
  nb_instance                            = 2
  vm_os_simple                           = "UbuntuServer"
  vnet_subnet_id                         = "${module.network.vnet_subnets[0]}"
  load_balancer_backend_address_pool_ids = "${module.loadbalancer.azurerm_lb_backend_address_pool_id}"
}

output "vmss_id" {
  value = "${module.vmss-cloudinit.vmss_id}"
}

#Required Inputs
These variables must be set in the module block when using this module. 
cloudconfig_file 
Description: The location of the cloud init configuration file. 
load_balancer_backend_address_pool_ids 
Description: The id of the backend address pools of the loadbalancer to which the VM scale set is attached 
vnet_subnet_id 
Description: The subnet id of the virtual network on which the vm scale set will be connected 
Optional Inputs
These variables have default values and don't have to be set to use this module. You may set these variables to override their default values. 
admin_password 
Description: The admin password to be used on the VMSS that will be deployed. The password must meet the complexity requirements of Azure 
Default: ""
admin_username 
Description: The admin username of the VMSS that will be deployed 
Default: "azureuser"
computer_name_prefix 
Description: The prefix that will be used for the hostname of the instances part of the VM scale set 
Default: "vmss"
data_disk_size 
Description: Specify the size in GB of the data disk 
Default: "10"
location 
Description: The location where the resources will be created 
Default: ""
managed_disk_type 
Description: Type of managed disk for the VMs that will be part of this compute group. Allowable values are 'Standard_LRS' or 'Premium_LRS'. 
Default: "Standard_LRS"
nb_instance 
Description: Specify the number of vm instances 
Default: "1"
network_profile 
Description: The name of the network profile that will be used in the VM scale set 
Default: "terraformnetworkprofile"
resource_group_name 
Description: The name of the resource group in which the resources will be created 
Default: "vmssrg"
ssh_key 
Description: Path to the public key to be used for ssh access to the VM 
Default: "~/.ssh/id_rsa.pub"
tags 
Description: A map of the tags to use on the resources that are deployed with this module. 
Default: { "source": "terraform" }
vm_os_id 
Description: The ID of the image that you want to deploy if you are using a custom image. 
Default: ""
vm_os_offer 
Description: The name of the offer of the image that you want to deploy 
Default: ""
vm_os_publisher 
Description: The name of the publisher of the image that you want to deploy 
Default: ""
vm_os_simple 
Description: Specify Ubuntu or Windows to get the latest version of each os 
Default: ""
vm_os_sku 
Description: The sku of the image that you want to deploy 
Default: ""
vm_os_version 
Description: The version of the image that you want to deploy. 
Default: "latest"
vm_size 
Description: Size of the Virtual Machine based on Azure sizing 
Default: "Standard_A0"
vmscaleset_name 
Description: The name of the VM scale set that will be created in Azure 
Default: "vmscaleset"

#Output

vmss_id
Description: (no description specified)

#Resources 
This is the list of resources that the module may create. The module can create zero or more of each of these resources depending on the count value. The count value is determined at runtime. The goal of this page is to present the types of resources that may be created. 
This list contains all the resources this plus any submodules may create. When using this module, it may create less resources if you use a submodule. 
This module defines 2 resources. 
azurerm_resource_group.vmss
azurerm_virtual_machine_scale_set.vm-linux
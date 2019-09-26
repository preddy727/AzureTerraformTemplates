variable "vm_size" {
  default = "Standard_DS2_v2"

  description = "Size of the Virtual Machine based on Azure sizing"
}

variable "vmscaleset_name" {
  default = "vmscaleset"

  description = "The name of the VM scale set that will be created in Azure"
}

variable "computer_name_prefix" {
  default = "vmss"

  description = "The prefix that will be used for the hostname of the instances part of the VM scale set"
}

variable "managed_disk_type" {
  default = "Premium_LRS"

  description = "Type of managed disk for the VMs that will be part of this compute group. Allowable values are 'Standard_LRS' or 'Premium_LRS'."
}

variable "data_disk_size" {
  description = "Specify the size in GB of the data disk"
  default     = "10"
}

/*
variable "admin_username" {
  description = "The admin username of the VMSS that will be deployed"
  default     = "azureuser"

}



variable "admin_password" {

  description = "The admin password to be used on the VMSS that will be deployed. The password must meet the complexity requirements of Azure"

  default     = ""

}
*/

variable "ssh_key" {
  description = "Path to the public key to be used for ssh access to the VM"
  default     = "~/.ssh/id_rsa.pub"
}

variable "nb_instance" {
  description = "Specify the number of vm instances"
  default     = "2"
}

/*
variable "vnet_subnet_id" {
  description = "The subnet id of the virtual network on which the vm scale set will be connected"
  default = ""
}
*/

variable "network_profile" {
  default = "terraformnetworkprofile"

  description = "The name of the network profile that will be used in the VM scale set"
}

variable "vm_os_simple" {
  description = "Specify Ubuntu or Windows to get the latest version of each os"

  default = "RHEL"
}

/*
variable "vm_os_publisher" {

  description = "The name of the publisher of the image that you want to deploy"

  default     = ""

}



variable "vm_os_offer" {

  description = "The name of the offer of the image that you want to deploy"

  default     = ""

}
 

variable "vm_os_sku" {

  description = "The sku of the image that you want to deploy"

  default     = ""

}
*/

variable "vm_os_version" {
  description = "The version of the image that you want to deploy."

  default = "latest"
}

variable "vm_os_id" {
  description = "The ID of the image that you want to deploy if you are using a custom image."

  default = ""
}

/*
variable "load_balancer_backend_address_pool_ids" {

  description = "The id of the backend address pools of the loadbalancer to which the VM scale set is attached"

}
*/

variable "tags" {
  type = map(string)

  description = "A map of the tags to use on the resources that are deployed with this module."

  default = {
    source = "terraform"
  }
}

/*
variable "cloudconfig_file" {

  description = "The location of the cloud init configuration file."

}
*/

variable "pl_rg" {
  description = "The name of the resource group"
  default     = ""
}

variable "pl_location" {
  description = "location of resources"
  default     = "eastus"
}

variable "pl_tags" {
  description = "A map of the tags to use for the resources that are deployed"
  type        = map(string)

  default = {
    environment = "dev"
  }
}

variable "pl_vnet" {
  description = "name of Private Link VNET"
  default     = "att-pedemo-workload-vnet"
}

variable "pl_vnet_addr_space" {
  description = "VNET Address space"
  default     = "10.0.0.0/16"
}

variable "pl_net_policy" {
  description = "Private Link Service Network Policy"
  default     = "Disabled"
}

variable "pe_net_policy" {
  description = "Private Endpoint Service Network Policy"
  default     = "Disabled"
}

variable "pl_nsg" {
  description = "NSG name"
  default     = "terraform-nsg"
}

variable "pl_subnet" {
  description = "Default Private Link subnet"
  default     = "testSubnet"
}

variable "pl_subnet_prefix" {
  description = "Default subnet prefix"
  default     = "10.0.1.0/24"
}

variable "pl_public_ip" {
  description = "Public IP"
  default     = "testPip"
}

variable "pl_public_ip_sku" {
  description = "Public IP SKU"
  default     = "Standard"
}

variable "pl_public_ip_alloc" {
  description = "Public IP allocation method"
  default     = "Static"
}

variable "pl_lb" {
  description = "Private Link Load Balancer"
  default     = "testlb"
}

variable "pl_lb_sku" {
  description = "LB SKU"
  default     = "Standard"
}

variable "pe_name" {
  description = "Private Endpoint Name"
  default     = "testpe"
}

variable "pl_service_connection" {
  description = "Private Link Service Connections"
  default     = "testplsconnection"
}

variable "pl_service" {
  description = "Private Link Service"
  default     = "testpls"
}

variable "pl_service_pvt_ip" {
  description = "Private Link Service IP Address"
  default     = "10.0.1.17"
}

variable "pl_service_pvt_ip_version" {
  description = "Private Link Service IP Address version"
  default     = "IPv4"
}

variable "pl_service_pvt_ip_alloc" {
  description = "Private Link Service IP Address allocation method"
  default     = "Static"
}

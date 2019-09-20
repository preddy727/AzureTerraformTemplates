variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created"
  default = "__resource_group_name__"
}

variable "keyvaultname" {
  description = "The name of the key vault used for disk encryption"
  default = "__keyvaultname__"
}

variable "forward_port" {
  }

variable "to_port" {
  }

variable "to_addr" {
  }



variable "location" {
  description = "The location where the resources will be created"
  default = "__location__"
}

variable "shared_image_resource_group" {
  default = "__shared_image_resource_group__"
}

variable "shared_image_version" {
  default = "__shared_image_version__"
}

variable "vm_size" {
  default = "__vm_size__"
}

variable "nb_instance" {
   default = "__nb_instance__"
}

variable "admin_username" {
  default = "__admin_username__"
}

variable "shared_image_gallery_name" {
  default = "__shared_image_gallery_name__"
}

variable "shared_image_name" {
  default = "__shared_image_name__"
}

variable "admin_password" {
  default = "__admin_password__"
}

variable "name_prefix" {
  default = "__name_prefix__"
}

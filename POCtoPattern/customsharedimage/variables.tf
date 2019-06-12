variable "image_gallery_resource_group_name" {
  description = "The name of the resource group in which the resources will be created"
  default = "__image_gallery_resource_group_name__"
}
variable "image_gallery_name" {
  description = "The name of the image gallery resource to publish the image to. This resource will be already created."
  default = "__image_gallery_name__"
}
variable "image_name" {
  description = "Name of shared image resource created by Packer."
  default = "__packer_target_vmimagename__"
}
variable "image_resource_group_name" {
  description = "Name of resource group where Packer created the image resource."
  default = "__packer_resource_group__"
}
variable "target_shared_image_version" {
  description = "Version of the image when it gets published to the shared image gallery."
  default = "__target_shared_image_version__"
}
variable "target_shared_image_location" {
  description = "Location where the shared image will be published."
  default = "__target_shared_image_location__"
}
variable "regional_replica_count" {
    description = "The number of replicas of the image in a given region"
    default = "__regional_replica_count__"
}
variable "os_type" {
    description = "Type of operating system in the image. Ex: Linux"  
    default = "__packer_image_os_type__"
}
variable "publisher_name" {
    description = "The name of the Publisher of the image"
    default = "__mktplace_image_publisher__"
}
variable "offer_name" {
    description = "The name of the Offer of the image" 
    default = "__mktplace_image_offer__"
}
variable "sku" {
    description = "The name of the sku of the image" 
    default = "__mktplace_image_sku__"
}
variable "shared_image_gallery_image_publisher_name" {
    description = "The publisher name in the local shared img gallery" 
    default = "__shared_image_gallery_image_publisher_name__"
}

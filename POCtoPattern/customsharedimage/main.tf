data "azurerm_resource_group" "img_gallery_rg" {
  name     = "${var.image_gallery_resource_group_name}"
}

data "azurerm_shared_image_gallery" "img_gallery" {
  name                = "${var.image_gallery_name}"
  resource_group_name = "${data.azurerm_resource_group.img_gallery_rg.name}"
}

data "azurerm_image" "packer_img" {
  name                = "${var.image_name}"
  resource_group_name = "${var.image_resource_group_name}"
}

resource "azurerm_shared_image" "shared_img" {
  name                = "${data.azurerm_image.packer_img.name}"
  gallery_name        = "${data.azurerm_shared_image_gallery.img_gallery.name}"
  resource_group_name = "${data.azurerm_shared_image_gallery.img_gallery.resource_group_name}"
  location            = "${data.azurerm_shared_image_gallery.img_gallery.location}"
  os_type             = "${var.os_type}"

  identifier {
    publisher = "${var.shared_image_gallery_image_publisher_name}"
    offer     = "${var.offer_name}"
    sku       = "${var.sku}"
  }
}

resource "azurerm_shared_image_version" "shared_img_version" {
  name                = "${var.target_shared_image_version}"
  gallery_name        = "${data.azurerm_shared_image_gallery.img_gallery.name}"
  image_name          = "${data.azurerm_image.packer_img.name}"
  resource_group_name = "${data.azurerm_shared_image_gallery.img_gallery.resource_group_name}"
  location            = "${data.azurerm_shared_image_gallery.img_gallery.location}"
  managed_image_id    = "${data.azurerm_image.packer_img.id}"

  target_region {
    name                   = "${var.target_shared_image_location}"
    regional_replica_count = "${var.regional_replica_count}"
  }

  depends_on = ["azurerm_shared_image.shared_img"]
}

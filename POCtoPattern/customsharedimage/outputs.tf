output "customsharedimage_id" {

  value = "${azurerm_shared_image.shared_img.*.id}"

}
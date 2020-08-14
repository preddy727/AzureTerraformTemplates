
# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.20.0"
  features {}
}

resource "azurerm_resource_group" "test" {

  name     = "example-resources"

  location = "East US"

}



data "azurerm_subscription" "primary" {}



resource "azurerm_role_definition" "existing" {

  name        = "my-custom-role"

  scope       = "${azurerm_shared_image.existing.id}"

  description = "This is a custom role created via Terraform"

 

  permissions {

    actions     = ["*"]

    not_actions = []

  }

 

  assignable_scopes = [

    "${data.azurerm_subscription.primary.id}"

  ]

}





resource "azurerm_shared_image_gallery" "existing" {

  name                = "example_image_gallery"

  resource_group_name = "${azurerm_resource_group.test.name}"

  location            = "${azurerm_resource_group.test.location}"

  description         = "Shared images and things."



  tags {

    Hello = "There"

    World = "Example"

  }

}



resource "azurerm_shared_image" "existing" {

  name                = "my-image"

  gallery_name        = "${azurerm_shared_image_gallery.existing.name}"

  resource_group_name = "${azurerm_resource_group.test.name}"

  location            = "${azurerm_resource_group.test.location}"

  os_type             = "Linux"



  identifier {

    publisher = "PublisherName"

    offer     = "OfferName"

    sku       = "ExampleSku"

  }

}



data "azurerm_image" "existing" {

  name                = "mypackerimage3"

  resource_group_name = "Client-VM2"

}



data "azurerm_shared_image" "existing" {

  name                = "my-image" 

  gallery_name        = "${azurerm_shared_image_gallery.existing.name}"

  resource_group_name = "${azurerm_resource_group.test.name}"

}





resource "azurerm_shared_image_version" "test" {

  name                = "0.0.1"

  gallery_name        = "${data.azurerm_shared_image.existing.gallery_name}"

  image_name          = "${data.azurerm_shared_image.existing.name}"

  resource_group_name = "${data.azurerm_shared_image.existing.resource_group_name}"

  location            = "${data.azurerm_shared_image.existing.location}"

  managed_image_id    = "${data.azurerm_image.existing.id}"



  target_region {

    name                   = "${data.azurerm_shared_image.existing.location}"

    regional_replica_count = "5"

  }

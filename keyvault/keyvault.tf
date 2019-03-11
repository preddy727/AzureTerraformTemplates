resource "azurerm_resource_group" "test" {
  name     = "Client-VM2"
  location = "West US 2"
}

resource "azurerm_key_vault" "test" {
  name                        = "testvaultprithvi"
  location                    = "${azurerm_resource_group.test.location}"
  resource_group_name         = "${azurerm_resource_group.test.name}"
  enabled_for_disk_encryption = true
  tenant_id                   = ""

  sku {
    name = "standard"
  }

  access_policy {
    tenant_id = ""
    object_id = ""

    key_permissions = [
      "backup", "create", "decrypt", "delete", "encrypt", "get", "import", "list", "purge", "recover", "restore", "sign", "unwrapKey", "update", "verify", "wrapKey",
    ]

    secret_permissions = [
      "backup", "delete", "get", "list", "purge", "recover", "restore","set",
    ]
  }

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags {
    environment = "Sandbox"
  }
}

resource "azurerm_key_vault_key" "generated" {
  name      = "generated-certificate"
  key_vault_id = "${azurerm_key_vault.test.id}"
  key_type  = "RSA"
  key_size  = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "vault_rg" {
  name     = "${var.name_prefix}-rg"
  location = "${var.location}"
}

resource "azurerm_key_vault" "vm_vault" {
  name                        = "${var.name_prefix}-vault"
  location                    = "${azurerm_resource_group.vault_rg.location}"
  resource_group_name         = "${azurerm_resource_group.vault_rg.name}"
  enabled_for_disk_encryption = true
  tenant_id                   = "${data.azurerm_client_config.current.tenant_id}"

  sku {
    name = "${var.vault_sku}"
  }

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    # virtual_network_subnet_ids  = "[${var.permitted_subnets}]"
  }

  tags {
    environment = "${lookup(var.environment_map, var.environment, var.environment)}"
  }
}

resource "azurerm_key_vault_key" "generated" {
  name      = "generated-certificate"
  key_vault_id = "${azurerm_key_vault.vm_vault.id}"
  key_type  = "RSA"
  key_size  = 2048

  key_opts = "${var.key_opts}"
}
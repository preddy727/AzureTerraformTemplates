output "vault_key" {
  value = "${
    map(
      "id", "azurerm_key_vault_key.generated.id",
      "key_type", "azurerm_key_vault_key.generated.key_type",
      "version", "azurerm_key_vault_key.generated.version"
    )
  }"
}

output "vault" {
  value = "${
    map(
      "id", "azurerm_key_vault.vm_vault.id",
      "uri", "azurerm_key_vault.vm_vault.uri",
      "tenant_id", "azurerm_key_vault.vm_vault.tenant_id"
    )
  }"
}

# Obtener datos del usuario actual autenticado en Azure CLI
data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "kv_01" {
  name                          = var.kv_01_name
  location                      = azurerm_resource_group.rg_01.location
  resource_group_name           = azurerm_resource_group.rg_01.name
  enabled_for_disk_encryption   = true
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false
  public_network_access_enabled = true
  enable_rbac_authorization     = true
  sku_name                      = "standard"
  tags                          = var.tags

}

# Crear secreto en Key Vault
resource "azurerm_key_vault_secret" "keyvault_secret" {
  name         = "KEYVAULT-VALUE"
  value        = var.kv_secret_value
  key_vault_id = azurerm_key_vault.kv_01.id

  depends_on = [azurerm_role_assignment.identity_kv_secrets_02]
}




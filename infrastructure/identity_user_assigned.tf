
#IDENTITY USER - ASIGNED : PERMISOS KEYVAULT Y CONTAINER REGISTRY
resource "azurerm_user_assigned_identity" "identity_01" {
  resource_group_name = azurerm_resource_group.rg_01.name
  location            = azurerm_resource_group.rg_01.location
  name                = var.identity_01_name
  tags                = var.tags
}

resource "azurerm_role_assignment" "identity_kv_secrets" {
  scope                = azurerm_key_vault.kv_01.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.identity_01.principal_id
}

resource "azurerm_role_assignment" "identity_kv_secrets_02" {
  scope                = azurerm_key_vault.kv_01.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}
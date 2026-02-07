# Outputs para obtener información después del despliegue

output "resource_group_name" {
  description = "Nombre del Resource Group"
  value       = azurerm_resource_group.rg_01.name
}

output "backend_fqdn" {
  description = "FQDN del backend Container App"
  value       = azurerm_container_app.backend.ingress[0].fqdn
}

output "frontend_fqdn" {
  description = "FQDN del frontend Container App"
  value       = azurerm_container_app.frontend.ingress[0].fqdn
}

output "keyvault_name" {
  description = "Nombre del Key Vault"
  value       = azurerm_key_vault.kv_01.name
}

output "keyvault_id" {
  description = "ID del Key Vault"
  value       = azurerm_key_vault.kv_01.id
}

output "user_identity_id" {
  description = "ID de la identidad asignada por el usuario"
  value       = azurerm_user_assigned_identity.identity_01.id
}

output "user_identity_principal_id" {
  description = "Principal ID de la identidad asignada por el usuario"
  value       = azurerm_user_assigned_identity.identity_01.principal_id
}

output "backend_url" {
  description = "URL del backend para testing"
  value       = "https://${azurerm_container_app.backend.ingress[0].fqdn}/saludo"
}

output "frontend_url" {
  description = "URL del frontend"
  value       = "https://${azurerm_container_app.frontend.ingress[0].fqdn}"
}

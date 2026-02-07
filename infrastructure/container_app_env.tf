# Usar el Container App Environment existente
data "azurerm_container_app_environment" "cae_01" {
  name                = "env-javier"
  resource_group_name = "rg-javierhuaman"
}

# ===== CONTAINER APP BACKEND =====
resource "azurerm_container_app" "backend" {
  name                         = var.backend_name
  container_app_environment_id = data.azurerm_container_app_environment.cae_01.id
  resource_group_name          = azurerm_resource_group.rg_01.name
  revision_mode                = "Single"
  
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity_01.id]
  }
  
  template {
    min_replicas = 1
    container {
      name   = "backend"
      image  = var.backend_image
      cpu    = 0.25
      memory = "0.5Gi"
      
      # Variables de entorno para el backend
      env {
        name  = "PORT"
        value = "8080"
      }
      env {
        name  = "KEYVAULT_VALUE"
        value = azurerm_key_vault_secret.keyvault_secret.value
      }
    }
  }
  
  ingress {
    external_enabled           = true
    target_port                = 8080
    allow_insecure_connections = false
    
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

# ===== CONTAINER APP FRONTEND =====
resource "azurerm_container_app" "frontend" {
  name                         = var.frontend_name
  container_app_environment_id = data.azurerm_container_app_environment.cae_01.id
  resource_group_name          = azurerm_resource_group.rg_01.name
  revision_mode                = "Single"
  
  template {
    min_replicas = 1
    container {
      name   = "frontend"
      image  = var.frontend_image
      cpu    = 0.25
      memory = "0.5Gi"
      
      # Pasar URL del backend al frontend
      env {
        name  = "BACKEND_URL"
        value = "https://${azurerm_container_app.backend.ingress[0].fqdn}"
      }
    }
  }
  
  ingress {
    external_enabled           = true
    target_port                = 80
    allow_insecure_connections = false
    
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}
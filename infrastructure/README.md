# Infraestructura - Terraform para Azure

## 📌 Descripción

Configuración de infraestructura como código (IaC) usando Terraform para desplegar la aplicación completa en Azure Container Apps.

## 🛠️ Stack Tecnológico

- **IaC Tool**: Terraform 1.0+
- **Cloud Provider**: Microsoft Azure
- **Recursos**: Container Apps, Resource Group, Storage Account, Azure Files

## 📁 Estructura

```
infrastructure/
├── provider.tf              # Configuración del proveedor Azure
├── variables.tf             # Variables de entrada
├── terraform.tfvars         # Valores específicos del entorno
├── resource_group.tf        # Resource Group
├── container_app_env.tf     # Container Apps (backend + frontend)
├── azure_files.tf           # Azure Files
└── README.md                # Este archivo
```

## 📄 Archivos de Configuración

### provider.tf
Define:
- Proveedor Azure Resource Manager
- Versión mínima requerida de Terraform
- Versión mínima del proveedor AzureRM

```hcl
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

### variables.tf
Define todas las variables de entrada:
- `location`: Región de Azure
- `tags`: Etiquetas para organizacion
- `rg_01_name`: Nombre del Resource Group
- `backend_image`: URL de imagen Docker del backend
- `frontend_image`: URL de imagen Docker del frontend
- `backend_name`: Nombre del Container App (backend)
- `frontend_name`: Nombre del Container App (frontend)

### terraform.tfvars
Valores específicos para tu entorno:
```hcl
location = "East US 2"
tags = {
  Environment = "Desarrollo"
  Department  = "TI"
  Clase       = "DMC"
}
rg_01_name = "rg-mjllanos-dev-eastus2-001"
backend_image = "mjllanosc/app-back-saludo-01:v1.0"
frontend_image = "mjllanosc/app-front-saludo-01:v1.0"
```

### resource_group.tf
Crea el Resource Group principal:
```hcl
resource "azurerm_resource_group" "rg_01" {
  name     = var.rg_01_name
  location = var.location
  tags     = var.tags
}
```

### container_app_env.tf
Define dos Container Apps:

**Backend Container App:**
- Nombre: configurable
- Imagen: `mjllanosc/app-back-saludo-01:v1.0`
- Puerto: `8080`
- Réplicas mínimas: `1`
- Recursos: `0.25 CPU`, `0.5Gi RAM`
- Variables de entorno: `PORT=8080`
- CORS: Habilitado
- Acceso: FQDN público asignado por Azure

**Frontend Container App:**
- Nombre: configurable
- Imagen: configurable
- Puerto: `80` (Nginx)
- Réplicas mínimas: `1`
- Recursos: `0.25 CPU`, `0.5Gi RAM`
- Variables de entorno: `BACKEND_URL=https://<backend-fqdn>`
- Acceso: FQDN público asignado por Azure

**Nota:** Usan un Container App Environment compartido (`env-javier`)

### azure_files.tf
Define:
- Storage Account para almacenamiento persistente
- File Share para compartir datos entre contenedores

## 🚀 Guía de Despliegue

### 1. Requisitos Previos

```bash
# Instalar Terraform
# https://www.terraform.io/downloads

# Instalar Azure CLI
# https://learn.microsoft.com/en-us/cli/azure/install-azure-cli

# Conectarse a Azure
az login
```

### 2. Preparar Archivos

```bash
cd infrastructure

# Actualizar terraform.tfvars con tus valores
# - Región (location)
# - Nombres únicos de recursos
# - URLs de imágenes Docker
```

**Ejemplo terraform.tfvars:**
```hcl
location = "East US 2"
rg_01_name = "rg-tu-empresa-dev-eastus2-001"
backend_image = "tuuser/app-back-saludo-01:v1.0"
frontend_image = "tuuser/app-front-saludo-01:v1.0"
```

### 3. Inicializar Terraform

```bash
terraform init
```

Descargará proveedores y módulos necesarios.

### 4. Validar Configuración

```bash
terraform validate
```

Verifica que la sintaxis sea correcta.

### 5. Revisar Cambios

```bash
terraform plan
```

Muestra qué se creará/modificará/eliminará en Azure.

### 6. Aplicar Cambios

```bash
terraform apply
```

Crea los recursos en Azure. Confirma escribiendo `yes`.

### 7. Obtener Salidas

```bash
terraform output
```

Mostrará:
- FQDN del backend
- FQDN del frontend
- Otros valores importantes

## 📋 Recursos Creados

| Recurso | Nombre | Descripción |
|---|---|---|
| Resource Group | `rg-mjllanos-dev-eastus2-001` | Grupo principal |
| Container App | `ca-backend-saludo` | Microservicio backend |
| Container App | `ca-frontend-saludo` | Aplicación web frontend |
| Storage Account | `stmjllanoseastus201` | Almacenamiento persistente |
| File Share | `share-mjllanos-eastus2-001` | Compartir datos |

## 🔐 Gestión de Secretos (Azure Key Vault)

Para inyectar `KEYVAULT_VALUE` desde Azure Key Vault:

1. **Crear Key Vault:**
```bash
az keyvault create \
  --name "kv-tu-app" \
  --resource-group "rg-tu-empresa-dev-eastus2-001" \
  --location "East US 2"
```

2. **Agregar secreto:**
```bash
az keyvault secret set \
  --vault-name "kv-tu-app" \
  --name "KEYVAULT-VALUE" \
  --value "tu-secreto-aqui"
```

3. **Configurar Managed Identity:**
Actualizar `container_app_env.tf` para usar MSI y leer Key Vault.

4. **Inyectar en Container App:**
```hcl
env {
  name  = "KEYVAULT_VALUE"
  value = data.azurerm_key_vault_secret.keyvault_value.value
}
```

## 🔄 Ciclo de Vida

### Actualizar Configuración

```bash
# Editar terraform.tfvars or variables
# Luego:
terraform plan
terraform apply
```

### Escalar (más CPU/RAM)

```hcl
# En container_app_env.tf:
cpu    = 0.5    # Aumentar de 0.25
memory = "1Gi"  # Aumentar de 0.5Gi
```

### Destruir Recursos

```bash
terraform destroy
```

**⚠️ Cuidado:** Esto elimina todos los recursos creados por Terraform.

## 📝 Variables de Entorno en Containers

### Backend
```hcl
env {
  name  = "PORT"
  value = "8080"
}
# KEYVAULT_VALUE debe ser inyectada desde Key Vault
```

### Frontend
```hcl
env {
  name  = "BACKEND_URL"
  value = "https://${azurerm_container_app.backend.ingress[0].fqdn}"
}
```

## 🌐 Acceso a la Aplicación

Después de desplegar:

```bash
# Obtener URLs
terraform output

# Ejemplo de salida:
# backend_fqdn = "ca-backend-saludo.agreeablebeach-123456.eastus2.azurecontainerapps.io"
# frontend_fqdn = "ca-frontend-saludo.agreeablebeach-123456.eastus2.azurecontainerapps.io"
```

- **Frontend**: `https://ca-frontend-saludo.****.azurecontainerapps.io`
- **Backend**: `https://ca-backend-saludo.****.azurecontainerapps.io/saludo`

## 📊 Monitoreo

### Ver logs en Azure
```bash
az containerapp logs show \
  --name ca-backend-saludo \
  --resource-group rg-mjllanos-dev-eastus2-001
```

### Ver estado
```bash
az containerapp show \
  --name ca-backend-saludo \
  --resource-group rg-mjllanos-dev-eastus2-001
```

## 🐛 Troubleshooting

### Error: Authentication required
```bash
az login
```

### Error: Resource group not found
Crear primero:
```bash
az group create \
  --name rg-tu-empresa-dev-eastus2-001 \
  --location "East US 2"
```

### Container app no inicia
Revisar logs:
```bash
az containerapp logs show \
  --name ca-backend-saludo \
  --resource-group rg-mjllanos-dev-eastus2-001
```

## 📚 Estado de Terraform

Terraform guarda el estado en `terraform.tfstate`:
- ⚠️ **Confidencial**: No commitear a Git
- ✅ Agregar a `.gitignore`
- Para producción: usar `terraform backend` (Azure Storage)

## 🔗 Links Útiles

- [Terraform Docs](https://www.terraform.io/docs)
- [Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Container Apps Docs](https://learn.microsoft.com/en-us/azure/container-apps/)
- [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/)

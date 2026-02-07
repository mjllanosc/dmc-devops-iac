variable "location" {
  description = "La ubicación donde se creará el componente"
  type        = string
}

variable "tags" {
  description = "Etiquetas opcionales para aplicar al componente"
  type        = map(string)
  default = {
    Environment = ""
  }
}

// RESOURCE GROUP 01------------------------------- 
variable "rg_01_name" {
  description = "El nombre del grupo de recursos 1"
  type        = string
}

// Storage Account 01
variable "st_01_name" {
  description = "Nombre del storage account"
  type        = string
}

// Container Apps(ca) & Environments(cae) 01

variable "cae_01_workload_profile" {
  description = "El Workload del cae 01"
  type        = string
}

variable "cae_01_name" {
  description = "El nombre del cae 01"
  type        = string
}

variable "aca_01_name" {
  description = "El nombre del aca 01"
  type        = string
}

variable "backend_image" {
  description = "Imagen Docker del backend"
  type        = string
}

variable "backend_name" {
  description = "Nombre del container app del backend"
  type        = string
  default     = "ca-backend-saludo"
}

variable "frontend_image" {
  description = "Imagen Docker del frontend"
  type        = string
}

variable "frontend_name" {
  description = "Nombre del container app del frontend"
  type        = string
  default     = "ca-frontend-saludo"
}

//Azure Files 01

variable "share_01_name" {
  description = "Nombre del Azure Files"
  type        = string
}

// Identity
variable "identity_01_name" {
  description = "Nombre de la identidad asignada por el usuario"
  type        = string
}

// Key Vault
variable "kv_01_name" {
  description = "Nombre del Key Vault"
  type        = string
}

variable "kv_secret_value" {
  description = "Valor del secreto KEYVAULT_VALUE"
  type        = string
  sensitive   = true
}
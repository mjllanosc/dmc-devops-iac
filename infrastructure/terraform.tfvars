location = "East US 2"
tags = {
  Environment = "Desarrollo"
  Department  = "TI"
  Clase       = "DMC"
}
// RESOURCE GROUP 01------------------------------- 
rg_01_name = "rg-mjllanos-dev-eastus2-001"

// Environments(cae)
cae_01_name             = "cae-mjllanos-dev-eastus2-001"
cae_01_workload_profile = "Consumption"

// Container Apps(ca)
aca_01_name = "ca-mjllanos-dev-eastus2-001"

st_01_name = "stmjllanoseastus201"

share_01_name = "share-mjllanos-eastus2-001"

// Container App Images
backend_image  = "docker.io/mjllanosc/app-back-saludo-01:v1.0"
frontend_image = "docker.io/mjllanosc/app-front-saludo-01:v1.0"


//identity
identity_01_name = "id-mjllanos-dev-eastus2-001"

//Keyvault
kv_01_name             = "kvmjllanosdeveastus2001"
kv_secret_value        = "mi-secreto-desde-keyvault"
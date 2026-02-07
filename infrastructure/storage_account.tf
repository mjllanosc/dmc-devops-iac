resource "azurerm_storage_account" "st_01" {
  name                     = var.st_01_name
  resource_group_name      = azurerm_resource_group.rg_01.name
  location                 = azurerm_resource_group.rg_01.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
# Azure Files Share
resource "azurerm_storage_share" "share_01" {
  name                 = var.share_01_name
  storage_account_name = azurerm_storage_account.st_01.name
  quota                = 1
}

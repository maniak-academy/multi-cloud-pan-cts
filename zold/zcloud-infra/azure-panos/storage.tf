

resource "random_id" "suffix" {
  byte_length = 2
}

resource "azurerm_storage_account" "pnfwbootstrap" {
  name                     = "pnfwbootstrap${random_id.suffix.dec}"
  resource_group_name      = var.resource_group_name
  location = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "pnfwshare" {
  name                 = "bootstrap"
  storage_account_name = azurerm_storage_account.pnfwbootstrap.name
  quota                = 50
}

resource "azurerm_storage_share_directory" "pnfwsharedir" {
  name                 = "config"
  share_name           = azurerm_storage_share.pnfwshare.name
  storage_account_name = azurerm_storage_account.pnfwbootstrap.name
}
resource "azurerm_storage_share_directory" "pnfwsharedircontent" {
  name                 = "content"
  share_name           = azurerm_storage_share.pnfwshare.name
  storage_account_name = azurerm_storage_account.pnfwbootstrap.name
}
resource "azurerm_storage_share_directory" "pnfwsharedirlicense" {
  name                 = "license"
  share_name           = azurerm_storage_share.pnfwshare.name
  storage_account_name = azurerm_storage_account.pnfwbootstrap.name
}
resource "azurerm_storage_share_directory" "pnfwsharedirsoftware" {
  name                 = "software"
  share_name           = azurerm_storage_share.pnfwshare.name
  storage_account_name = azurerm_storage_account.pnfwbootstrap.name
}
resource "azurerm_storage_share_file" "panfwinit-cfg" {
  name             = "init-cfg.txt"
  storage_share_id = azurerm_storage_share.pnfwshare.id
  source           = "${path.module}/init-cfg.txt"
  path = azurerm_storage_share_directory.pnfwsharedir.name
}

resource "azurerm_storage_share_file" "panfwaccesscode" {
  name             = "authcodes"
  storage_share_id = azurerm_storage_share.pnfwshare.id
  source           = "${path.module}/authcodes"
  path = azurerm_storage_share_directory.pnfwsharedir.name
}




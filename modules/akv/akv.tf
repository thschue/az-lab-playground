data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "training_global_rg" {
  name = var.resource_group_name
}

resource "random_string" "random_suffix" {
  length  = 4
  special = false
  upper   = false
  lower   = true
  numeric = false
}

resource "azurerm_key_vault" "training_kv" {
  name                       = "training-kv-${random_string.random_suffix.result}"
  location                   = data.azurerm_resource_group.training_global_rg.location
  resource_group_name        = data.azurerm_resource_group.training_global_rg.name
  sku_name                   = "standard"
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
    ]

    key_permissions = [
      "Get",
      "List",
      "Create",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
    ]
  }

  lifecycle {
    ignore_changes = [
      access_policy
    ]
  }
}


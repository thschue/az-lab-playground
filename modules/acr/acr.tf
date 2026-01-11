resource "random_string" "random_suffix" {
  length  = 4
  special = false
  upper   = false
  lower   = true
  numeric = false
}

resource "azurerm_container_registry" "aks_acr" {
  name                = "k8strainingacr${random_string.random_suffix.result}"
  location            = var.region
  sku                 = "Basic"
  resource_group_name = var.resource_group_name
  admin_enabled       = false
  tags = {
    Environment = "Training"
  }
}

resource "azurerm_container_registry_cache_rule" "ghcr_cache_rule" {
  container_registry_id = azurerm_container_registry.aks_acr.id
  name                  = "ghcr-cache-rule"
  target_repo           = "ghcr/*"
  source_repo           = "ghcr.io/*"
}

resource "azurerm_container_registry_cache_rule" "quay_cache_rule" {
  container_registry_id = azurerm_container_registry.aks_acr.id
  name                  = "quay-cache-rule"
  target_repo           = "quay/*"
  source_repo           = "quay.io/*"
}

resource "azurerm_container_registry_cache_rule" "ecr_cache_rule" {
  container_registry_id = azurerm_container_registry.aks_acr.id
  name                  = "ecr-cache-rule"
  target_repo           = "ecr/*"
  source_repo           = "public.ecr.aws/*"
}
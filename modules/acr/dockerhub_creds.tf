resource "azurerm_key_vault_secret" "dockerhub_username" {
  name         = "dockerhub-username"
  value        = var.dockerhub_username
  key_vault_id = var.akv_id
}

resource "azurerm_key_vault_secret" "dockerhub_password" {
  name         = "dockerhub-password"
  value        = var.dockerhub_password
  key_vault_id = var.akv_id
}

resource "azurerm_container_registry_credential_set" "dockerhub" {
  name                  = "dockerhub"
  container_registry_id = azurerm_container_registry.aks_acr.id
  login_server          = "docker.io"

  identity {
    type = "SystemAssigned"
  }

  authentication_credentials {
    username_secret_id = azurerm_key_vault_secret.dockerhub_username.versionless_id
    password_secret_id = azurerm_key_vault_secret.dockerhub_password.versionless_id
  }
}

resource "azurerm_role_assignment" "dockerhub_credential_set_kv_secrets_user" {
  scope                = azurerm_container_registry.aks_acr.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_container_registry_credential_set.dockerhub.identity[0].principal_id
}

resource "azurerm_key_vault_access_policy" "dockerhub_credential_set" {
  key_vault_id = var.akv_id
  tenant_id    = azurerm_container_registry_credential_set.dockerhub.identity[0].tenant_id
  object_id    = azurerm_container_registry_credential_set.dockerhub.identity[0].principal_id

  secret_permissions = [
    "Get"
  ]
}

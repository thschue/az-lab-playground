resource "azurerm_user_assigned_identity" "eso_identity" {
  name                = "eso-identity"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
}

resource "azurerm_role_assignment" "eso_kv_access" {
  principal_id         = azurerm_user_assigned_identity.eso_identity.principal_id
  role_definition_name = "Key Vault Secrets User"
  scope                = var.akv_id
}

resource "azurerm_federated_identity_credential" "eso_identity" {

  name                = "eso-identity-fic"
  resource_group_name = azurerm_kubernetes_cluster.aks_cluster.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks_cluster.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.eso_identity.id
  subject             = "system:serviceaccount:external-secrets:external-secrets-sa"
}

resource "azurerm_key_vault_access_policy" "eso_kv_access" {
  key_vault_id = var.akv_id
  tenant_id    = azurerm_kubernetes_cluster.aks_cluster.identity[0].tenant_id
  object_id    = azurerm_user_assigned_identity.eso_identity.principal_id

  secret_permissions = [
    "Get",
  ]
}
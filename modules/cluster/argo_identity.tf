resource "azurerm_user_assigned_identity" "argo_identity" {
  name                = "${local.cluster_name}-argo-identity"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
}

resource "azurerm_role_assignment" "argo_access" {
  principal_id                     = azurerm_user_assigned_identity.argo_identity.principal_id
  role_definition_name             = "AcrPull"
  scope                            = var.dns_zone_id
  skip_service_principal_aad_check = true
}

resource "azurerm_federated_identity_credential" "argo_identity" {
  name                = "${local.cluster_name}-argo-identity-fic"
  resource_group_name = azurerm_kubernetes_cluster.aks_cluster.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks_cluster.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.argo_identity.id
  subject             = "system:serviceaccount:argocd:argocd-repo-server"
}
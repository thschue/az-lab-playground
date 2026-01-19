resource "azurerm_user_assigned_identity" "agw_identity" {
  name                = "azure-alb-identity"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
}

resource "azurerm_role_assignment" "agw_reader_access" {
  principal_id                     = azurerm_user_assigned_identity.agw_identity.principal_id
  role_definition_name             = "Reader"
  scope                            = azurerm_resource_group.aks_rg.id
  skip_service_principal_aad_check = true
}

resource "azurerm_federated_identity_credential" "agw_identity" {
  name                = "${local.cluster_name}-agw-identity-fic"
  resource_group_name = azurerm_kubernetes_cluster.aks_cluster.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks_cluster.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.agw_identity.id
  subject             = "system:serviceaccount:azure-alb-system:alb-controller-sa"
}

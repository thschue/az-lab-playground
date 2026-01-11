resource "azurerm_user_assigned_identity" "dns_identity" {
  name                = "edns-identity"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
}

resource "azurerm_role_assignment" "dns_access" {
  principal_id                     = azurerm_user_assigned_identity.dns_identity.principal_id
  role_definition_name             = "DNS Zone Contributor"
  scope                            = var.dns_zone_id
  skip_service_principal_aad_check = true
}

# resource "azurerm_role_assignment" "dns_access_read" {
#   principal_id                     = azurerm_user_assigned_identity.dns_identity.principal_id
#   role_definition_name             = "Reader"
#   scope                            = var.global_resource_group_id
# }

resource "azurerm_federated_identity_credential" "edns_identity" {
  name                = "edns-identity-fic"
  resource_group_name = azurerm_kubernetes_cluster.aks_cluster.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks_cluster.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.dns_identity.id
  subject             = "system:serviceaccount:external-dns:external-dns-sa"
}

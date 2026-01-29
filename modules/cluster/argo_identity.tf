resource "azurerm_federated_identity_credential" "argo_identity" {
  name                = "${local.cluster_name}-argo-identity-fic"
  resource_group_name = var.argo_identity_rg_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks_cluster.oidc_issuer_url
  parent_id           = var.argo_identity_id
  subject             = "system:serviceaccount:argocd:argocd-repo-server"
}
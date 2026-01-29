resource "azurerm_role_assignment" "argo_access" {
  principal_id                     = var.argo_service_descriptor
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.aks_acr.id
  skip_service_principal_aad_check = true
}
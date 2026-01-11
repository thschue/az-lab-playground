output "acr_id" {
  description = "The ID of the Azure Container Registry."
  value       = azurerm_container_registry.aks_acr.id
}
output "akv_id" {
  description = "The ID of the Azure Container Registry."
  value       = azurerm_key_vault.training_kv.id
}
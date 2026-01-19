output "cluster_name" {
  value = local.cluster_name
}

output "edns_identity_client_id" {
    description = "The User Assigned Identity for External DNS."
    value       = azurerm_user_assigned_identity.cm_identity.client_id
}

output "eso_identity_client_id" {
  description = "The User Assigned Identity for External DNS."
  value       = azurerm_user_assigned_identity.cm_identity.client_id
}

output "cert_manager_identity_client_id" {
  description = "The User Assigned Identity for External DNS."
  value       = azurerm_user_assigned_identity.cm_identity.client_id
}

output "argo_identity_client_id" {
  description = "The User Assigned Identity for Argo."
  value       = azurerm_user_assigned_identity.argo_identity.client_id
}


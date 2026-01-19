data "azuredevops_users" "assignee" {
  principal_name = data.azuread_user.assignee.user_principal_name
}

resource "azuredevops_git_repository" "base_repo" {
  project_id     = var.devops_project_id
  default_branch = "refs/heads/main"
  initialization {
    init_type = "Clean"
  }
  name = "${var.cluster_name}-gitops-base"
}

resource "azuredevops_git_repository" "tenant_repo" {
  project_id     = var.devops_project_id
  default_branch = "refs/heads/main"
  initialization {
    init_type = "Clean"
  }
  name = "${var.cluster_name}-gitops-tenant"
}

resource "azuredevops_git_repository" "code_repo" {
  project_id     = var.devops_project_id
  default_branch = "refs/heads/main"
  initialization {
    init_type = "Clean"
  }
  name = "${var.cluster_name}-code"
}

resource "azuredevops_service_principal_entitlement" "workload_sp" {
  origin_id = azurerm_user_assigned_identity.argo_identity.principal_id
  origin    = "aad" # Sourced from Azure Active Directory
}

# Argo Identity permissions
data "azuredevops_group" "readers" {
  project_id = var.devops_project_id
  name       = "Readers"
}

resource "azuredevops_group_membership" "readers_membership" {
  group = data.azuredevops_group.readers.id
  members = [
    azuredevops_service_principal_entitlement.workload_sp.descriptor
  ]
  lifecycle {
    ignore_changes = [group]
  }
}

resource "azuredevops_git_permissions" "argo_base_repo_permissions" {
  project_id    = var.devops_project_id
  repository_id = azuredevops_git_repository.base_repo.id
  principal     = azuredevops_service_principal_entitlement.workload_sp.descriptor
  permissions = {
    "GenericRead" = "Allow"
  }
}

resource "azuredevops_git_permissions" "argo_tenant_repo_permissions" {
  project_id    = var.devops_project_id
  repository_id = azuredevops_git_repository.tenant_repo.id
  principal     = azuredevops_service_principal_entitlement.workload_sp.descriptor
  permissions = {
    "GenericRead" = "Allow"
  }
}
#
#
# # User permissions
# resource "azuredevops_git_permissions" "user_code_repo_permissions" {
#   project_id    = data.azuredevops_project.project.id
#   repository_id = azuredevops_git_repository.code_repo.id
#   principal  = data.azuredevops_users.assignee.id
#   permissions = {
#     "Administer" = "Allow"
#   }
# }
#
# resource "azuredevops_git_permissions" "user_base_repo_permissions" {
#   project_id    = data.azuredevops_project.project.id
#   repository_id = azuredevops_git_repository.base_repo.id
#   principal  = data.azuredevops_users.assignee.id
#   permissions = {
#     "Administer" = "Allow"
#   }
# }
#
# resource "azuredevops_git_permissions" "user_tenant_repo_permissions" {
#   project_id    = data.azuredevops_project.project.id
#   repository_id = azuredevops_git_repository.tenant_repo.id
#   principal  = data.azuredevops_users.assignee
#   permissions = {
#     "Administer" = "Allow"
#   }
# }


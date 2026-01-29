resource "azuredevops_git_repository" "base_repo" {
  project_id     = var.devops_project_id
  default_branch = "refs/heads/main"
  initialization {
    init_type = "Clean"
  }
  name = "${var.cluster_name}-gitops-base"

  lifecycle {
    prevent_destroy = true
  }
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


# Argo Identity permissions
data "azuredevops_group" "readers" {
  project_id = var.devops_project_id
  name       = "Readers"
}

resource "azuredevops_git_permissions" "argo_base_repo_permissions" {
  project_id    = var.devops_project_id
  repository_id = azuredevops_git_repository.base_repo.id
  principal     = var.argo_devops_service_descriptor
  permissions = {
    "GenericRead" = "Allow"
  }
}

resource "azuredevops_git_permissions" "argo_tenant_repo_permissions" {
  project_id    = var.devops_project_id
  repository_id = azuredevops_git_repository.tenant_repo.id
  principal     = var.argo_devops_service_descriptor
  permissions = {
    "GenericRead" = "Allow"
  }
}


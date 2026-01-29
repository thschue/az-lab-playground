data "azuredevops_project" "project" {
  name = var.devops_project_name
}

data "azurerm_user_assigned_identity" "argo_identity" {
  name                = var.argo_identity_name
  resource_group_name = var.argo_identity_rg_name
}

data "azuredevops_service_principal" "workload_sp" {
  display_name = var.argo_identity_name
}

resource "azurerm_resource_group" "global_rg" {
  location = var.region
  name     = "${var.training_name_prefix}-rg-training-global"
}

module "dns" {
  source              = "./modules/dns"
  dns_zone_name       = var.dns_zone_name
  resource_group_name = azurerm_resource_group.global_rg.name
  depends_on = [
    azurerm_resource_group.global_rg
  ]
}

module "acr" {
  source                  = "./modules/acr"
  region                  = var.region
  resource_group_name     = azurerm_resource_group.global_rg.name
  dockerhub_password      = var.dockerhub_password
  dockerhub_username      = var.dockerhub_username
  akv_id                  = module.akv.akv_id
  argo_service_descriptor = data.azurerm_user_assigned_identity.argo_identity.principal_id
  depends_on = [
    azurerm_resource_group.global_rg
  ]
}

module "akv" {
  source              = "./modules/akv"
  resource_group_name = azurerm_resource_group.global_rg.name
  depends_on = [
    azurerm_resource_group.global_rg
  ]
}

module "aks_cluster" {
  for_each             = var.cluster_names
  source               = "./modules/cluster"
  acr_id               = module.acr.acr_id
  akv_id               = module.akv.akv_id
  rg_prefix            = var.training_name_prefix
  cluster_name         = each.key
  participant_upn      = each.value
  authorized_ip_ranges = var.authorized_ip_ranges
  dns_zone_id          = module.dns.dns_zone_id
  devops_project_id    = data.azuredevops_project.project.id

  depends_on = [
    module.acr,
    module.akv
  ]
  argo_devops_service_descriptor = data.azuredevops_service_principal.workload_sp.descriptor
  argo_identity_id               = data.azurerm_user_assigned_identity.argo_identity.id
  argo_identity_rg_name          = var.argo_identity_rg_name
}


locals {
  cluster_name = "${var.rg_prefix}-aks-${var.cluster_name}"
}

resource "azurerm_resource_group" "aks_rg" {
  name     = local.cluster_name
  location = var.region
  tags = {
    Environment = "Training"
    Cluster     = var.cluster_name
  }
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  #checkov:skip=CKV_AZURE_4:"For our training lab, local logging is sufficient."
  #checkov:skip=CKV_AZURE_115:"We want to enable public access for training purposes."
  #checkov:skip=CKV_AZURE_116:"Azure Policies are not in scope for this training lab."
  #checkov:skip=CKV_AZURE_170:"For our training, a free SKU is sufficient."
  #checkov:skip=CKV_AZURE_232:"In this training also other pods than system pods should be able to use the default node pool."

  name                = local.cluster_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = var.cluster_name

  api_server_access_profile {
    authorized_ip_ranges = var.authorized_ip_ranges
  }

  identity {
    type = "SystemAssigned"
  }


  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  tags = {
    Environment = "Training"
    Cluster     = var.cluster_name
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_data_plane  = "cilium"
    pod_cidr            = "192.168.0.0/16"
    network_policy      = "cilium"
  }
  automatic_upgrade_channel = "stable"

  default_node_pool {
    name                    = "default"
    host_encryption_enabled = true
    vm_size                 = "Standard_D2ads_v5"
    node_count              = 2
    min_count               = 1
    max_count               = 3
    max_pods                = 110
    auto_scaling_enabled    = true
    node_public_ip_enabled  = false
    os_disk_type            = "Ephemeral"
    os_disk_size_gb         = 40
    upgrade_settings {
      max_surge                     = "10%"
      drain_timeout_in_minutes      = 0
      node_soak_duration_in_minutes = 0
    }
    tags = {
      Environment = "Training"
      Cluster     = var.cluster_name
    }
  }
}

resource "azurerm_role_assignment" "example" {

  principal_id                     = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
}



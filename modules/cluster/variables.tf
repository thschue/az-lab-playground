variable "cluster_name" {
  description = "The name of the Kubernetes cluster."
  type        = string
}

variable "authorized_ip_ranges" {
  description = "List of authorized IP ranges for API server access."
  type        = list(string)
}

variable "region" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = "Austria East"
}

variable "acr_id" {
  description = "The ID of the Azure Container Registry."
  type        = string
}

variable "akv_id" {
  description = "The ID of the Azure Key Vault."
  type        = string
}

variable "rg_prefix" {
  description = "The prefix for naming resources in the training environment."
  type        = string
}

variable "dns_zone_id" {
  description = "The name of the DNS zone to be created."
  type        = string
}

variable "devops_project_id" {
  description = "The name of the Azure DevOps project."
  type        = string
}

variable "participant_upn" {
  description = "UPN of the participant for role assignments."
  type        = string
}

variable "argo_identity_id" {
  description = "The name of the Argo CD managed identity."
  type        = string
}

variable "argo_identity_rg_name" {
  description = "The name of the Argo CD managed identity."
  type        = string
  default     = ""
}

variable "argo_devops_service_descriptor" {
  description = "The Azure DevOps service principal descriptor for Argo Workflows."
  type        = string
}

variable "node_count" {
  description = "The number of nodes in the default node pool."
  type        = number
  default     = 1
}

variable "node_type" {
  description = "The VM size for the nodes in the default node pool."
  type        = string
  default     = "Standard_B2s_v2"
}

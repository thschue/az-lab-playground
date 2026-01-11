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

variable "global_resource_group_id" {
  description = "The name of the global Resource Group where shared resources are located."
  type        = string
}
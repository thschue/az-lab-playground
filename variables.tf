variable "training_name_prefix" {
  description = "The prefix for naming resources in the training environment."
  type        = string
}

variable "cluster_names" {
  description = "The name of the Kubernetes clusters."
  type        = map(string)
}

variable "subscription_id" {
  description = "The subscription ID where resources will be created."
  type        = string
}

variable "authorized_ip_ranges" {
  description = "List of authorized IP ranges for API server access."
  type        = list(string)
  default     = []
}

variable "region" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = "Austria East"
}

variable "tenant_id" {
  description = "The Azure Tenant ID."
  type        = string
}

variable "dns_zone_name" {
  description = "The name of the DNS zone to be created."
  type        = string
}

variable "devops_project_name" {
  description = "The name of the Azure DevOps project."
  type        = string
}

variable "devops_organization_url" {
  description = "The URL of the Azure DevOps organization."
  type        = string
}

variable "dockerhub_username" {
  description = "The Docker Hub username for container image storage."
  type        = string
  sensitive   = true
}

variable "dockerhub_password" {
  description = "The Docker Hub password for container image storage."
  type        = string
  sensitive   = true
}

variable "argo_identity_name" {
  description = "The name of the Argo CD managed identity."
  type        = string
}

variable "argo_identity_rg_name" {
  description = "The name of the Argo CD managed identity."
  type        = string
  default     = ""
}


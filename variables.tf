variable "training_name_prefix" {
  description = "The prefix for naming resources in the training environment."
  type        = string
}

variable "cluster_names" {
  description = "The name of the Kubernetes clusters."
  type        = list(string)
  default     = ["test"]
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
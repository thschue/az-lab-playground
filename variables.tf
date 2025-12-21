variable "cluster_names" {
  description = "The name of the Kubernetes clusters."
  type        = list(string)
  default     = ["test"]
}

variable "subscription_id" {
  description = "The subscription ID where resources will be created."
  type        = string
  default     = ""
}

variable "authorized_ip_ranges" {
  description = "List of authorized IP ranges for API server access."
  type = list(string)
  default = []
}

variable "region" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = "Austria East"
}
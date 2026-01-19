variable "region" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "dockerhub_username" {
  type      = string
  sensitive = true
}

variable "dockerhub_password" {
  type      = string
  sensitive = true
}

variable "akv_id" {
  type = string
}

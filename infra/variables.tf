variable "resource_group_name_prefix" {
  description = "Prefix for the resource group name"
  type        = string
  default     = "rg-" 
}

variable "resource_group_location" {
  description = "Location for the resource group"
  type        = string
  default     = "East US 2"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "acrdevopsamin"
}

variable "container_app_env_name" {
  description = "Name of the Azure Container App Environment"
  type        = string
  default     = "devops-env"
}
variable "resource_group_name" {
  description = "The resource group name to be imported"
  type        = string
}

variable "location" {
  description = "location"
  type        = string
}

variable "name" {
  description = "AKS name"
  type        = string
  default     = null
}

variable "kubernetes_version" {
  description = "Specify which Kubernetes release to use. The default used is the latest Kubernetes version available in the region"
  type        = string
  default     = null
}

variable "vm_size" {
  description = "vm_size"
  type        = string
}


variable "min_count" {
  description = "min_count"
  type        = string
}

variable "max_count" {
  description = "max_count"
  type        = string
}

variable "vnet_subnet_id" {
  description = "vnet_subnet_id."
  type        = string
}
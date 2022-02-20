variable "resource_group_name" {
  description = "The resource group name to be imported"
  type        = string
}

variable "location" {
  description = "location"
  type        = string
}

variable "name" {
  description = "vnet name"
  type        = string
  default     = null
}

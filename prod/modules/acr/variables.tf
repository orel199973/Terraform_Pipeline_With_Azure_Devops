variable "resource_group_name" {
  description = "The resource group name to be imported"
  type        = string
}

variable "location" {
  description = "location"
  type        = string
}

variable "acr_name" {
    description = "(Required) Specifies the name of the Container Registry.."
}
variable "sku" {
    description = "(Optional) The SKU name of the the container registry. Possible values are Basic, Standard and Premium. Default = Basic"
    default = "Basic"
}
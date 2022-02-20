variable "resource_group_name" {
  type        = string
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "name" {
  type        = string
}

variable "kubernetes_version" {
  type        = string
  default = "1.19.13"
}

variable "vm_size" {
  type        = string
  default = "Standard_B2s"
}

# variable "acr_name" {
#   type    = string
# }

variable "sku" {
  type    = string
  default = "Standard"
}

variable "min_count" {
  type    = string
  default = "1"
}
variable "max_count" {
    type    = string
  default = "3"
}

# variable "vnet_name" {
#   type    = string
# }

# ariable "dns_name" {
#  type        = string
# 
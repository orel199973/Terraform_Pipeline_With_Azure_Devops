# Create a resource group.
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create a acr.
# The name used for the Container Registry needs to be globally unique
module "acr" {
        source  = "../modules/acr"
        acr_name                  = format("%sshtechacr", var.name)
        resource_group_name       = azurerm_resource_group.rg.name
        location                  = var.location
        sku                       = var.sku
}

# Create a vnet.
module "vnet" {
  source              = "../modules/vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  name                = format("%sVnet", var.name)

  
}

# Create a aks.
module "aks" {
        source  = "../modules/aks"
        resource_group_name              = azurerm_resource_group.rg.name
        location                         = var.location
        name                             = var.name
        kubernetes_version               = var.kubernetes_version
        vm_size                          = var.vm_size
        min_count                        = var.min_count
        max_count                        = var.max_count
        vnet_subnet_id                   = module.vnet.vnet_subnet_id

        depends_on = [module.vnet]
}


# Create a role assignmen.
resource "azurerm_role_assignment" "role_acrpull" {
  scope                            = module.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = module.aks.kubelet_identity.0.object_id
  skip_service_principal_aad_check = true
}

# Create a role assignmen with acr thirdparty.
resource "azurerm_role_assignment" "role_acrpull_thirdparty" {
  scope                            = "/subscriptions/...shtech"
  role_definition_name             = "AcrPull"
  principal_id                     = module.aks.kubelet_identity.0.object_id
  skip_service_principal_aad_check = true
}

# Create a DNS.
module "dns" {
  source              = "../modules/dns"
  dns_name                = format("%s.shtech.io", var.name)
  resource_group_name = azurerm_resource_group.rg.name
}

# Assign role to kubelet identity that allows ALL pods to update DNS records.
resource "azurerm_role_assignment" "role_dns-zone" {
  scope                            = module.dns.id
  role_definition_name             = "DNS Zone Contributor"
  principal_id                     = module.aks.kubelet_identity.0.object_id
  skip_service_principal_aad_check = true
}
# Create a resource group.
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create a acr.
module "acr" {
        source  = "../modules/acr"
        acr_name                  = format("%sshtechthirdpartyacr", var.name)
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
  scope                            = "/subscriptions/shtechthirdparty"
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

# Create a eventhub namespace.
resource "azurerm_eventhub_namespace" "eventhub_namespace" {
  name                = format("%s-eventhub-namespace", var.name)
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  capacity            = 1
  
  depends_on = [module.aks]

}

# Create a eventhub.
resource "azurerm_eventhub" "eventhub" {
  name                = format("%s-eventhub", var.name)
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace.name
  resource_group_name = azurerm_resource_group.rg.name
  partition_count     = 2
  message_retention   = 1
}

# Create a stream analytics.
resource "azurerm_stream_analytics_job" "stream_analytics" {
  name                                     = format("%s-job", var.name)
  resource_group_name                      = azurerm_resource_group.rg.name
  location                                 = var.location
  compatibility_level                      = "1.2"
  data_locale                              = "en-GB"
  events_late_arrival_max_delay_in_seconds = 60
  events_out_of_order_max_delay_in_seconds = 50
  events_out_of_order_policy               = "Adjust"
  output_error_policy                      = "Drop"
  streaming_units                          = 3

  transformation_query = <<QUERY
    SELECT *
    INTO [YourOutputAlias]
    FROM [YourInputAlias]
QUERY

}

# Create a storage account. 
resource "azurerm_storage_account" "storage_account" {
  name                     = format("%ssa", var.name)
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}



# Create a data lake gen2 filesystem.
resource "azurerm_storage_data_lake_gen2_filesystem" "gen2_filesystem" {
  name               = format("%s-gen2-filesystem", var.name)
  storage_account_id = azurerm_storage_account.storage_account.id

  properties = {
    hello = "aGVsbG8="
  }
}


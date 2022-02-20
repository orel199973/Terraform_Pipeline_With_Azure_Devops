# Create AKS cluster
resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix = "DNSprefix"
  kubernetes_version  = var.kubernetes_version
  

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "nodepool"
    vm_size    = var.vm_size
    enable_auto_scaling = true
    min_count = var.min_count
    max_count = var.max_count
    vnet_subnet_id = var.vnet_subnet_id
  }

  network_profile {
    load_balancer_sku = "Standard"
    network_plugin    = "kubenet"
  }

}
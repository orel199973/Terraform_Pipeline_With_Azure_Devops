# Create a Vnet.
resource azurerm_virtual_network "vnet" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
  dns_servers         = []
}

# Create a Subnet.
resource "azurerm_subnet" "subnet" {
    name                        = "subnet"
    resource_group_name         = var.resource_group_name
    virtual_network_name        = azurerm_virtual_network.vnet.name
    address_prefix              = "10.0.1.0/24"
}







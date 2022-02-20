# Create a DNS Zone.
resource "azurerm_dns_zone" "dns_zone" {
  name                = var.dns_name
  resource_group_name = var.resource_group_name
}
resource "azurerm_private_dns_zone" "private_dns" {
  name                = var.private_dns_name
  resource_group_name = var.resource_group_name
  depends_on =[azurerm_resource_group.main]
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_link" {
  name                  = var.private_link_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns.name
  virtual_network_id    = azurerm_virtual_network.main.id
  depends_on =[azurerm_virtual_network.main, azurerm_private_dns_zone.private_dns, azurerm_resource_group.main]
}

resource "azurerm_dns_zone" "public_dns" {
  name                = var.public_dns_name
  resource_group_name = var.resource_group_name
  depends_on =[azurerm_resource_group.main]
}
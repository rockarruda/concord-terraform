resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.aksVnet_address_space
  dns_servers         = var.aksVnet_dns_servers
  depends_on = [azurerm_resource_group.main]
}

resource "azurerm_subnet" "main" {
  name                 = var.subnet_name
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = var.resource_group_name
  address_prefix       = var.aksSubnet_address_prefix
  depends_on = [azurerm_virtual_network.main, azurerm_resource_group.main]
}
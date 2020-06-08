resource "azurerm_virtual_network_peering" "peer_to_ad" {
  name                      = var.peer_to_ad_name
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.main.name
  remote_virtual_network_id = var.remote_AD_subnet_id
  depends_on =[azurerm_virtual_network.main, azurerm_resource_group.main]
}

resource "azurerm_virtual_network_peering" "peer_from_ad" {
  name                      = var.peer_from_ad_name
  resource_group_name       = var.AD_resource_group_name
  virtual_network_name      = var.AD_Vnet_name
  remote_virtual_network_id = azurerm_virtual_network.main.id
  depends_on =[azurerm_virtual_network.main]
}
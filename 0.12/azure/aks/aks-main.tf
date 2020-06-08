#data "azurerm_key_vault_secret" "terraform_aks_secret" {
#  name         = "terraform-secret"
#  key_vault_id = "/subscriptions/875ba59f-b2f5-462d-b161-38f1e865364f/resourceGroups/jimaks/providers/Microsoft.KeyVault/vaults/terraform-aks-vault"
#}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = var.node_pool_name
    node_count = var.node_pool_count
    vm_size    = var.node_pool_vm_size
    vnet_subnet_id = azurerm_subnet.main.id
  }

  network_profile {
      network_plugin = "azure"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = {
    Environment = var.tags
  }
  depends_on =[azurerm_subnet.main, azurerm_resource_group.main]
}

#resource "azurerm_virtual_network" "terraform_jimaks_vnet" {
#  name                = "terraform_jimaks_vnet"
#  location            = var.location
#  resource_group_name = var.resource_group_name
#  address_space       = var.aksVnet_address_space
#  dns_servers         = var.aksVnet_dns_servers
#  depends_on = [azurerm_resource_group.terraform_jimaks]
#}

#resource "azurerm_subnet" "terraform_subnet_jimaks" {
#  name                 = "internal"
#  virtual_network_name = azurerm_virtual_network.terraform_jimaks_vnet.name
#  resource_group_name  = var.resource_group_name
#  address_prefix       = var.aksSubnet_address_prefix
#  depends_on = [azurerm_virtual_network.terraform_jimaks_vnet, azurerm_resource_group.terraform_jimaks]
#}

#resource "azurerm_subnet_network_security_group_association" "terraform_subnet_assoc" {
#  subnet_id                 = azurerm_subnet.terraform_subnet_jimaks.id
#  network_security_group_id = azurerm_network_security_group.terraform_jimaks_nsg.id
#  depends_on = [azurerm_subnet.terraform_subnet_jimaks, azurerm_network_security_group.terraform_jimaks_nsg]
#}

#resource "azurerm_network_security_group" "terraform_jimaks_nsg" {
#  name                = "terraform_jimaks_nsg"
#  location            = var.location
#  resource_group_name = var.resource_group_name
#
#  security_rule {
#    name                       = "open_port_8443"
#    priority                   = 100
#    direction                  = "Inbound"
#    access                     = "Allow"
#    protocol                   = "Tcp"
#    source_port_range          = "*"
#    destination_port_range     = "8443"
#    source_address_prefix      = "*"
#    destination_address_prefix = "*"
#  }
#  depends_on = [azurerm_resource_group.terraform_jimaks]
#
#}

#resource "azurerm_virtual_network_peering" "terraform_jimaks_peer_ad" {
#  name                      = "terraform_peer_ad"
#  resource_group_name       = var.resource_group_name
#  virtual_network_name      = azurerm_virtual_network.terraform_jimaks_vnet.name
#  remote_virtual_network_id = var.remote_AD_subnet_id
#  depends_on =[azurerm_virtual_network.terraform_jimaks_vnet, azurerm_resource_group.terraform_jimaks]
#}

#resource "azurerm_virtual_network_peering" "peer_ad_terraform_jimaks" {
#  name                      = "peer_ad_terraform"
#  resource_group_name       = var.AD_resource_group_name
#  virtual_network_name      = var.AD_Vnet_name
#  remote_virtual_network_id = azurerm_virtual_network.terraform_jimaks_vnet.id
#  depends_on =[azurerm_virtual_network.terraform_jimaks_vnet]
#}

#resource "azurerm_private_dns_zone" "terraform_test_aks" {
#  name                = var.private_dns_name
#  resource_group_name = var.resource_group_name
#  depends_on =[azurerm_resource_group.terraform_jimaks]
#}

#resource "azurerm_private_dns_zone_virtual_network_link" "terraform_link_aks" {
#  name                  = "terraform_link_aks"
#  resource_group_name   = var.resource_group_name
#  private_dns_zone_name = azurerm_private_dns_zone.terraform_test_aks.name
#  virtual_network_id    = azurerm_virtual_network.terraform_jimaks_vnet.id
#  depends_on =[azurerm_virtual_network.terraform_jimaks_vnet, azurerm_private_dns_zone.terraform_test_aks, azurerm_resource_group.terraform_jimaks]
#}

#resource "azurerm_dns_zone" "terraform_public_aks" {
#  name                = "test.starburstdata.net"
#  resource_group_name = var.resource_group_name
#  depends_on =[azurerm_resource_group.terraform_jimaks]
#}

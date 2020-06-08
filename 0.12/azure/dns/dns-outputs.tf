output "private_dns" {
    value = azurerm_private_dns_zone.private_dns
}

output "public_dns" {
    value = azurerm_dns_zone.public_dns
}
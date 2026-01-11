output "dns_zone_id" {
  description = "The ID of the Azure DNS Zone."
  value = azurerm_dns_zone.dns_zone.id
}
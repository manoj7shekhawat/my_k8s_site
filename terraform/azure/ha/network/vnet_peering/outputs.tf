output "azurerm_virtual_network_peering_names" {
  value = values(azurerm_virtual_network_peering.vnet_peering)[*].name
}
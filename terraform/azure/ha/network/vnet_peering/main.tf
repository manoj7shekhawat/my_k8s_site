resource "azurerm_virtual_network_peering" "vnet_peering" {
  for_each = var.vnet_maps

  name                      = each.value.name
  resource_group_name       = each.value.resource_group_name
  virtual_network_name      = each.value.virtual_network_name
  remote_virtual_network_id = each.value.remote_virtual_network_id

  allow_gateway_transit        = false
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
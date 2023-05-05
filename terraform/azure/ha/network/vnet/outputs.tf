output "azurerm_virtual_network_name" {
  value = azurerm_virtual_network.vnet.name
}

output "azurerm_virtual_network_id" {
  value = azurerm_virtual_network.vnet.id
}

output "azurerm_virtual_network_rg_name" {
  value = azurerm_virtual_network.vnet.resource_group_name
}

output "node_subnet_id" {
  value = lookup(local.subnet_map, var.network.subnets.node_subnet.name ).id
}

output "pod_subnet_id" {
  value = lookup(local.subnet_map, var.network.subnets.pod_subnet.name ).id
}

output "agw_subnet_id" {
  value = lookup(local.subnet_map, var.network.subnets.agw_subnet.name ).id
}
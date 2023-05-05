output "azurerm_virtual_network_name" {
  value = values(module.network)[*].azurerm_virtual_network_name
}

output "node_subnet_id" {
  value = values(module.network)[*].node_subnet_id
}

output "pod_subnet_id" {
  value = values(module.network)[*].pod_subnet_id
}

output "azurerm_virtual_network_peering_names" {
  value = module.vnet_peering.azurerm_virtual_network_peering_names
}

output "aks_cluster_fqdn" {
  value = values(module.aks)[*].aks_cluster_fqdn
}

#output "peer_map" {
#  value = local.peer_map
#}

output "agw_public_ip_address" {
  value = module.public_ip.public_ip
}

output "agw_id" {
  value = module.agw.agw_id
}
module "network" {
  for_each = var.locations

  source = "./network/vnet"

  location            = each.value.location_name
  resource_group_name = each.value.resource_group_name

  network             = var.network[each.key]
  tags                = var.tags
}

locals {
  peer_map = {
    for k, v in module.network:
      k => {
        name                      = "peer_${k}_to_${tolist(setsubtract(keys(tomap(module.network)), [k]))[0]}"
        resource_group_name       = module.network[k].azurerm_virtual_network_rg_name
        virtual_network_name      = module.network[k].azurerm_virtual_network_name
        remote_virtual_network_id = module.network[tolist(setsubtract(keys(tomap(module.network)), [k]))[0]].azurerm_virtual_network_id
      }
  }
}

module "vnet_peering" {
  source = "./network/vnet_peering"
  vnet_maps = local.peer_map
}

module "aks" {
  for_each = var.locations

  source = "./container/aks"

  location            = each.value.location_name
  resource_group_name = each.value.resource_group_name

  aks_cluster         = var.aks_cluster
  service_principal_client_secret = var.service_principal_client_secret

  node_subnet_id      = module.network[each.key].node_subnet_id
  pod_subnet_id       = module.network[each.key].pod_subnet_id

  tags                = var.tags
}

module "public_ip" {
  source = "./network/public_ip"

  location            = var.locations["ne"].location_name
  resource_group_name = var.locations["ne"].resource_group_name

  public_ip_name = var.public_ip_name

  depends_on = [module.network]
}

module "agw" {
  source = "./network/application_gw"

  location            = var.locations["ne"].location_name
  resource_group_name = var.locations["ne"].resource_group_name

  agw = var.agw

  vnet_name    = var.network["ne"].vnet.name
  public_ip_id = module.public_ip.public_ip_id

  agw_subnet_id = module.network["ne"].agw_subnet_id
}
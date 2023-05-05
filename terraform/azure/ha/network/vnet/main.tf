resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.network.vnet.name
  address_space       = var.network.vnet.address_space
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  tags                = var.tags
}

resource "azurerm_subnet" "subnets" {
  for_each = var.network.subnets

  name                 = each.value.name
  resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.address_prefix]
  service_endpoints    = each.value.service_endpoints

  lifecycle {
    ignore_changes = [ delegation["aks-delegation"] ]
  }

  dynamic "delegation" {
    for_each = each.value.service_delegation == "None" ? [] : [1]
    content {
      name = each.value.service_delegation
      service_delegation {
        name    = each.value.service_delegation
      }
    }
  }
}

locals {
  subnet_map = {
  for k, v in azurerm_subnet.subnets:
  v.name => {
    id               = v.id
    address_prefixes = v.address_prefixes
  }
  }
}
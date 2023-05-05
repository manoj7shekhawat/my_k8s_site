# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${var.vnet_name}-beap"
  frontend_port_name             = "${var.vnet_name}-feport"
  frontend_ip_configuration_name = "${var.vnet_name}-feip"
  http_setting_name              = "${var.vnet_name}-be-htst"
  listener_name                  = "${var.vnet_name}-httplstn"
  request_routing_rule_name      = "${var.vnet_name}-rqrt"
  redirect_configuration_name    = "${var.vnet_name}-rdrcfg"
}

resource "azurerm_application_gateway" "application_gateway" {
  name                = var.agw.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = var.agw.sku.name
    tier     = var.agw.sku.tier
    capacity = var.agw.sku.capacity
  }

  gateway_ip_configuration {
    name      = var.agw.gateway_ip_configuration_name
    subnet_id = var.agw_subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = var.public_ip_id
  }

  backend_address_pool {
    name         = local.backend_address_pool_name
    ip_addresses = var.agw.backend_address_pool_ip_addresses
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
    probe_name            = var.agw.probe.name
    host_name                           = var.agw.probe.host_ip
    pick_host_name_from_backend_address = false
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 100
  }

  probe {
    name                                      = var.agw.probe.name
    protocol                                  = var.agw.probe.protocol
    path                                      = var.agw.probe.path
    #host                                      = var.agw.probe.host_ip
    pick_host_name_from_backend_http_settings = true
    interval                                  = 10
    timeout                                   = 60
    unhealthy_threshold                       = 3

    match {
      body        = ""
      status_code = [
        "200-399"
      ]
    }
  }
}
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name               = lower(replace("${var.aks_cluster.name}-${var.location}", " ", ""))
  location           = var.location
  dns_prefix         = lower(replace("${var.aks_cluster.dns_prefix}-${var.location}", " ", ""))
  kubernetes_version = var.aks_cluster.kubernetes_version

  lifecycle {
    ignore_changes = [default_node_pool[0].vnet_subnet_id, default_node_pool[0].pod_subnet_id]
  }

  resource_group_name = var.resource_group_name
  node_resource_group = lower(replace("${var.aks_cluster.node_resource_group}-${var.location}", " ", ""))

  default_node_pool {
    name                  = replace(lower(replace("${var.aks_cluster.default_node_pool.name}${var.location}", " ", "")), "europe", "eu")
    zones                 = var.aks_cluster.default_node_pool.zones
    vm_size               = var.aks_cluster.default_node_pool.vm_size
    enable_auto_scaling   = true
    enable_node_public_ip = false
    max_count             = var.aks_cluster.default_node_pool.max_count
    min_count             = var.aks_cluster.default_node_pool.min_count
    type                  = "VirtualMachineScaleSets"
    vnet_subnet_id        = var.node_subnet_id
    pod_subnet_id         = var.pod_subnet_id
    max_pods              = 100
    orchestrator_version  = var.aks_cluster.kubernetes_version
  }

  service_principal {
    client_id     = var.aks_cluster.service_principal_client_id
    client_secret = var.service_principal_client_secret
  }

  http_application_routing_enabled  = false
  role_based_access_control_enabled = true

  network_profile {
    network_plugin     = var.aks_cluster.network_profile.network_plugin
    network_policy     = var.aks_cluster.network_profile.network_policy
    service_cidr       = var.aks_cluster.network_profile.service_cidr
    dns_service_ip     = var.aks_cluster.network_profile.dns_service_ip
    load_balancer_sku  = var.aks_cluster.network_profile.load_balancer_sku
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  tags                            = var.tags
  azure_policy_enabled            = true
}
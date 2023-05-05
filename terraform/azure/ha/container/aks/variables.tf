variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "pod_subnet_id" {
  type = string
}

variable "node_subnet_id" {
  type = string
}

variable "service_principal_client_secret" {
  type = string
}

variable "aks_cluster" {
  type = object({
    name                                     = string
    dns_prefix                               = string
    node_resource_group                      = string
    kubernetes_version                       = string

    service_principal_client_id = string

    default_node_pool = object({
      name                  = string
      zones                 = list(number)
      vm_size               = string
      enable_auto_scaling   = bool
      enable_node_public_ip = bool
      max_count             = number
      min_count             = number
    })

    network_profile = object({
      network_plugin     = string
      network_policy     = string
      pod_cidr           = string
      service_cidr       = string
      dns_service_ip     = string
      load_balancer_sku  = string
    })
  })
}

variable "tags" {
  type = object({
    owner       = string
    environment = string
  })
}
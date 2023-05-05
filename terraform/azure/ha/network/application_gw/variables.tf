variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "agw_subnet_id" {
  type = string
}

variable "public_ip_id" {
  type = string
}

variable "agw" {
  type = object({
    name                              = string
    gateway_ip_configuration_name     = string
    backend_address_pool_ip_addresses = list(string)

    sku = object({
      name     = string
      tier     = string
      capacity = number
    })

    probe = object({
      name      = string
      protocol  = string
      path      = string
      host_ip   = string
    })
  })
}
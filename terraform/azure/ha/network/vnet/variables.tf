variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}


variable "network" {

  type = object({

    vnet = object({
      name          = string
      address_space = list(string)
    })
    subnets = map(object({
      name               = string
      address_prefix     = string
      service_delegation = string
      service_endpoints  = list(string)
    }))
  })
}

variable "tags" {
  type = object({
    owner       = string
    environment = string
  })
}
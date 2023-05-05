variable "locations" {
  type = map(object({
    location_name       = string
    resource_group_name = string
  }))
}


variable "network" {
  type = any
  description = "For root level"
}

variable "aks_cluster" {
  type        = any
  description = "For root level"
}

variable "service_principal_client_secret" {
  type = string
}

variable "public_ip_name" {
  type = string
}

variable "agw" {
  type        = any
  description = "For root level"
}

variable "tags" {
  type = any
  description = "For root level"
}
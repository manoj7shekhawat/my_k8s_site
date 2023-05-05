locations = {
  ne = {
    location_name       = "North Europe"
    resource_group_name = "mshekhawat-rg-ne"
  }

  we = {
    location_name       = "West Europe"
    resource_group_name = "mshekhawat-rg-we"
  }
}

network = {
  ne = {
    vnet = {
      name          = "infra-vnet-ne"
      address_space = ["10.20.0.0/20"]
    }
    subnets = {
      node_subnet = {
        name               = "aks-node-snet-ne"
        address_prefix     = "10.20.11.0/24"
        service_delegation = "None"
        service_endpoints  = ["Microsoft.KeyVault"]
      }

      pod_subnet = {
        name               = "aks-pod-snet-ne"
        address_prefix     = "10.20.12.0/24"
        service_delegation = "None"
        service_endpoints  = ["Microsoft.KeyVault"]
      }

      agw_subnet = {
        name               = "agw-pod-snet-ne"
        address_prefix     = "10.20.10.0/24"
        service_delegation = "None"
        service_endpoints  = ["Microsoft.KeyVault"]
      }
    }
  }
  we = {
    vnet = {
      name          = "infra-vnet-we"
      address_space = ["10.30.0.0/20"]
    }
    subnets = {
      node_subnet = {
        name               = "aks-node-snet-we"
        address_prefix     = "10.30.11.0/24"
        service_delegation = "None"
        service_endpoints  = ["Microsoft.KeyVault"]
      }

      pod_subnet = {
        name               = "aks-pod-snet-we"
        address_prefix     = "10.30.12.0/24"
        service_delegation = "None"
        service_endpoints  = ["Microsoft.KeyVault"]
      }

      agw_subnet = {
        name               = "agw-pod-snet-ne"
        address_prefix     = "10.30.10.0/24"
        service_delegation = "None"
        service_endpoints  = ["Microsoft.KeyVault"]
      }
    }
  }
}

aks_cluster = {
  name                                     = "mshekhawat-aks"
  dns_prefix                               = "mshekhawat-aks"
  node_resource_group                      = "mshekhawat-aks-nodes-rg"
  kubernetes_version                       = "1.26.3"

  service_principal_client_id = "8b9ce61d-b554-47dd-836d-a2ce4263eec0"
  default_node_pool = {
    name                  = "dp"
    zones                 = [1, 2, 3]
    vm_size               = "Standard_B4ms" # CPUs - 2, RAM - 16 GiB
    enable_auto_scaling   = true
    enable_node_public_ip = false
    max_count             = 4
    min_count             = 3
  }

  network_profile = {
    network_plugin    = "azure"
    network_policy    = "calico"
    pod_cidr          = "172.10.0.0/16"
    service_cidr      = "172.11.0.0/16"
    dns_service_ip    = "172.11.0.10"
    load_balancer_sku = "standard"
  }
}

agw = {
  name                              = "mshekhawat_agw_ne"
  gateway_ip_configuration_name     = "mshekhawat-ip-configuration"
  backend_address_pool_ip_addresses = ["10.20.11.40", "10.30.11.40"]

  sku = {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 5
  }

  probe = {
    name      = "mshekhawat_probe_name"
    protocol  = "Http"
    path      = "/cluster"
    host_ip   = "10.20.11.40"
  }
}

public_ip_name = "mshekhawat_pip"

tags = {
  owner       = "manoj.shekhawat@sap.com"
  environment = "dev"
}
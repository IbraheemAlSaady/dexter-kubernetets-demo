provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = "dexter-demo"
  location = var.location
}

module "network" {
  depends_on = [
    azurerm_resource_group.this
  ]

  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.this.name
  address_spaces      = ["10.52.0.0/16"]
  subnet_prefixes     = ["10.52.1.0/24"]
  subnet_names        = ["subnet1"]
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "dexter-obs"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  dns_prefix          = "dex"
  kubernetes_version  = "1.23.5"

  identity {
    type = "SystemAssigned"
  }


  default_node_pool {
    name               = "default"
    node_count         = 5
    vm_size            = "Standard_D2_v2"
    vnet_subnet_id     = module.network.vnet_subnets[0]
    availability_zones = [1]
  }
}

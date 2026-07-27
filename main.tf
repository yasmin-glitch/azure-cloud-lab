# 1. resource Group
resource "azurerm_resource_group" "rg" {
    name = var.resource_group_name
    location = var.location

    tags = {
        Enviroment = "Lab"
        ManagedBy = "Terraform"
    }
}

# 2. Hub Virtual Network & Subnet
resource "azurerm_virtual_network" "hub" {
    name = "hub-vnet"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space = var.hub_address_space 
}

resource "azurerm_subnet" "hub_shared" {
    name = "SharedServicesSubnet"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.hub.name
    address_prefixes = ["10.0.10.0/24"]
}

# 3. Production Spoke Virtual Network & Subnet
resource "azurerm_virtual_network" "prod" {
  name                = "prod-spoke-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.prod_address_space
}

resource "azurerm_subnet" "prod_app" {
  name                 = "App-Subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.prod.name
  address_prefixes     = ["10.1.1.0/24"]
}

# 4. Development Spoke Virtual Network & Subnet
resource "azurerm_virtual_network" "dev" {
  name                = "dev-spoke-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.dev_address_space
}

resource "azurerm_subnet" "dev_app" {
  name                 = "App-Subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.dev.name
  address_prefixes     = ["10.2.1.0/24"]
}

# 5. VNet Peerings: hub <-> Prod Spoke
resource "azurerm_virtual_network_peering" "hub_to_prod" {
    name = "hub-to-prod-peer"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.hub.name
    remote_virtual_network_id = azurerm_virtual_network.prod.id
    allow_virtual_network_access = true
    allow_forwarded_traffic = true
}

resource "azurerm_virtual_network_peering" "prod_to_hub" {
  name                         = "prod-to-hub-peer"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.prod.name
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
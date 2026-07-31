# 1. resource Group
resource "azurerm_resource_group" "rg" {
    name = terraform.workspace == "default" ? "rg-networking-lab" : "rg-${terraform.workspace}-networking-lab"
    location = var.location

    tags = {
        Enviroment = terraform.workspace
        ManagedBy = "Terraform"
    }
}

# 2. Hub Virtual Network & Subnet
module "hub" {
    source = "./modules/vnet"
    vnet_name = "vnet-hub-${terraform.workspace}"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space = var.hub_address_space

    tags = {
    Environment = terraform.workspace
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_subnet" "hub_shared" {
    name = "SharedServicesSubnet"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = module.hub.vnet_name
    address_prefixes = ["10.0.10.0/24"]
}

# 3. Production Spoke Virtual Network & Subnet
module "prod" {
    source = "./modules/vnet"
    vnet_name = "vnet-prod-${terraform.workspace}"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space = var.prod_address_space
    
    tags = {
        Environment = terraform.workspace
        ManagedBy   = "Terraform"
    }
}

resource "azurerm_subnet" "prod_app" {
  name                 = "App-Subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.prod.vnet_name
  address_prefixes     = ["10.1.1.0/24"]
}

# 4. Development Spoke Virtual Network & Subnet
module "dev" {
    source = "./modules/vnet"
    vnet_name = "vnet-dev-${terraform.workspace}"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space = var.dev_address_space
    
    tags = {
        Environment = terraform.workspace
        ManagedBy   = "Terraform"
    }
}

resource "azurerm_subnet" "dev_app" {
  name                 = "App-Subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.dev.vnet_name
  address_prefixes     = ["10.2.1.0/24"]
}

# 5. VNet Peerings: hub <-> Prod Spoke
resource "azurerm_virtual_network_peering" "hub_to_prod" {
    name = "hub-to-prod-peer"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = module.hub.vnet_name
    remote_virtual_network_id = module.prod.vnet_id
    allow_virtual_network_access = true
    allow_forwarded_traffic = true
}

resource "azurerm_virtual_network_peering" "prod_to_hub" {
  name                         = "prod-to-hub-peer"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = module.prod.vnet_name
  remote_virtual_network_id    = module.hub.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
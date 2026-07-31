output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "The deployed resource group"
}

output "hub_vnet_id" {
  value       = module.hub.vnet_id
  description = "The resource ID of the Hub VNet"
}
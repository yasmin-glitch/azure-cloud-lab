output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "The deployed resource group"
}

output "hub_vnet_id" {
  value       = module.hub.vnet_id
  description = "The resource ID of the Hub VNet"
}

output "edge_vm_public_ip" {
  value       = azurearm_public_ip.edge_ip.ip_address
  description = "The public IP address of the Edge Gateway VM"
}

output "edge_vm_private_ip" {
  value       = azurearm_network_interface.edge_nic.private_ip_address
  description = "The private IP address of the Edge Gateway VM"
  sensitive   = true
}
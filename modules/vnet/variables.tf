variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "address_space" {
  description = "The address space of the virtual network."
  type        = list(string)
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network."
  type        = string
}

variable "location" {
  description = "The location of the virtual network."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the virtual network."
  type        = map(string)
  default     = {}
}
variable "resource_group_name" {
  description = "Name of the central resource group"
  type        = string
  default     = "rg-networking-lab"
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
  default     = "uaenorth"
}

variable "hub_address_space" {
  description = "CIDR block for the Hub VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "prod_address_space" {
  description = "CIDR block for the Prod Spoke VNet"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "dev_address_space" {
  description = "CIDR block for the Dev Spoke VNet"
  type        = list(string)
  default     = ["10.2.0.0/16"]
}
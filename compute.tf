# 1. Public IP for the Edge Gateway
resource "azurerm_public_ip" "edge_ip" {
  name                = "pip-edge-gw-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.common_tags
}

# 2. Network Interface Card (NIC) inside subnet 1
resource "azurerm_network_interface" "edge_nic" {
  name                = "nic-edge-gw-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets["subnet1"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.edge_ip.id
  }

  tags = local.common_tags
}

# 3. Linux Virtual Machine (Edge Gateway Node)
resource "azurerm_linux_virtual_machine" "edge_vm" {
  name                = "vm-edge-gw-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B1s"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurearm_network_interface.edge_nic.id,
  ]

  # Cloud-init script: Automatically installs Docker on boot
  custom_data = base64encode(<<EOF
  #!/bin/bash
  apt-get update
  apt-get install -y docker.io
  systemctl start docker
  systemctl enable docker
  usermod -aG docker azureuser
  EOF
  )

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.ssh_key.public_key_openssh
  }

  tags = local.common_tags
}
# 4. Generate an SSH Key Pair automatically via Terraform
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
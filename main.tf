provider "azurerm" {
  subscription_id = "0cead613-b99d-4057-9b73-e282208bb4c4"
  features {
  }
}
resource "azurerm_resource_group" "githubrg" {
  name     = "mdrg"
  location = "east us"
}
resource "azurerm_public_ip" "exampleip" {
  name                = "example-ip"
  location            = azurerm_resource_group.githubrg.location
  resource_group_name = azurerm_resource_group.githubrg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "example-nic" {
  name                = "example-nic"
  location            = azurerm_resource_group.githubrg.location
  resource_group_name = azurerm_resource_group.githubrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.exampleip.id
  }
}

resource "azurerm_virtual_network" "example-vnet" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.githubrg.location
  resource_group_name = azurerm_resource_group.githubrg.name
}

resource "azurerm_subnet" "example-subnet" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.githubrg.name
  virtual_network_name = azurerm_virtual_network.example-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "example-nsg" {
  name                = "example-nsg"
  location            = azurerm_resource_group.githubrg.location
  resource_group_name = azurerm_resource_group.githubrg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "example-nic-nsg" {
  network_interface_id      = azurerm_network_interface.example-nic.id
  network_security_group_id = azurerm_network_security_group.example-nsg.id
}
resource "azurerm_linux_virtual_machine" "example-vm" {
  name                            = "example-vm"
  resource_group_name             = azurerm_resource_group.githubrg.name
  location                        = azurerm_resource_group.githubrg.location
  size                            = "Standard_DS1_v2"
  admin_username                  = "adminuser"
  admin_password                  = "Password123"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.example-nic.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
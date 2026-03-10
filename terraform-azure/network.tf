# Copyright IBM Corp. 2018

resource "azurerm_virtual_network" "network" {
  name                = "${var.app_name}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.resource_gp.location}"
  resource_group_name = "${azurerm_resource_group.resource_gp.name}"
}

resource "azurerm_subnet" "main" {
  name                 = "testsubnet"
  resource_group_name  = "${azurerm_resource_group.resource_gp.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_network_interface" "netint" {
  name                = "networkinterface-${count.index + 1}"
  location            = "${azurerm_resource_group.resource_gp.location}"
  resource_group_name = "${azurerm_resource_group.resource_gp.name}"
  count               = "${var.instance_count}"

  ip_configuration {
    name                          = "ipconfig-${count.index + 1}"
    subnet_id                     = "${azurerm_subnet.main.id}"
    private_ip_address_allocation = "dynamic"
  }
}

# Copyright IBM Corp. 2018

// AWS Network Details
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"

  tags {
    Name = "${var.app_name}-vpc-${var.networkEnv}"
    Owner = "${var.owner}"
  }
}

resource "aws_subnet" "sub" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = "${lookup(var.avail_zone, count.index)}"
  count = 2
  tags {
    Name = "${var.app_name}-subnet-${var.networkEnv}"
    Owner = "${var.owner}"
  }
}

// Azure Network Details
resource "azurerm_virtual_network" "network" {
    name = "${var.app_name}-network"
    address_space = [ "10.0.0.0/16"]
    location = "${azurerm_resource_group.resource_gp.location}"
    resource_group_name = "${azurerm_resource_group.resource_gp.name}"
}

resource "azurerm_subnet" "test" {
  name                 = "testsubnet"
  resource_group_name  = "${azurerm_resource_group.resource_gp.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       = "10.0.${count.index + 1}.0/24"
  count = 2
}

resource "azurerm_network_interface" "netint" {
  name                = "networkinterface-${count.index + 1}"
  location            = "${azurerm_resource_group.resource_gp.location}"
  resource_group_name = "${azurerm_resource_group.resource_gp.name}"
  count = 2
  ip_configuration {
    name                          = "ipconfig-${count.index + 1}"
    subnet_id                     = "${element(azurerm_subnet.test.*.id, count.index)}"
    private_ip_address_allocation = "dynamic"
  }
}
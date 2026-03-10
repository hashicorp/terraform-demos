# Copyright IBM Corp. 2018

// AWS Servers
provider "aws" {
    region = "${var.aws_region}"
}

resource "aws_instance" "server" {
  ami           = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  availability_zone = "${lookup(var.avail_zone, count.index)}"
  count = 2
  tags {
    Name = "${var.app_name}-server-${count.index}"
    owner = "Adam"
    TTL = 1
  }
  subnet_id = "${element(aws_subnet.sub.*.id, count.index)}"
}

// Azure Servers 

provider "azurerm" {}

resource "azurerm_resource_group" "resource_gp" {
    name = "${var.app_name}-rg"
    location = "${var.location}"
}

resource "azurerm_virtual_machine" "app_vm" {
  name                  = "${var.app_name}-vm-${count.index + 1}"
  location              = "${azurerm_resource_group.resource_gp.location}"
  resource_group_name   = "${azurerm_resource_group.resource_gp.name}"
  network_interface_ids = ["${element(azurerm_network_interface.netint.*.id, count.index)}"]
  vm_size               = "Standard_DS1_v2"
  count = 2
  delete_os_disk_on_termination = true

  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1-${count.index + 1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.app_name}-${count.index + 1}"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "staging"
  }
}

# Copyright IBM Corp. 2018

provider "azurerm" {}

data "terraform_remote_state" "networkdetails" {
  backend = "atlas"

  config {
    name = "azc/${var.network_workspace}"
  }
}

data "terraform_remote_state" "databasedetails" {
  count   = "${var.database_workspace == "" ? 0 : 1}"
  backend = "atlas"

  config {
    name = "azc/${var.database_workspace}"
  }
}

resource "azurerm_resource_group" "resource_gp" {
  name     = "${var.app_name}-rg"
  location = "${data.terraform_remote_state.networkdetails.location}"
}

resource "azurerm_network_interface" "netint" {
  name                = "networkinterface-${count.index + 1}"
  location            = "${azurerm_resource_group.resource_gp.location}"
  resource_group_name = "${azurerm_resource_group.resource_gp.name}"
  count               = "${var.instance_count}"

  ip_configuration {
    name                          = "ipconfig-${count.index + 1}"
    subnet_id                     = "${data.terraform_remote_state.networkdetails.mainsubnet}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "app_vm" {
  name                          = "${var.app_name}-vmexample-${count.index + 1}"
  location                      = "${azurerm_resource_group.resource_gp.location}"
  resource_group_name           = "${azurerm_resource_group.resource_gp.name}"
  network_interface_ids         = ["${element(azurerm_network_interface.netint.*.id, count.index)}"]
  vm_size                       = "Standard_DS1_v2"
  count                         = "${var.instance_count}"
  delete_os_disk_on_termination = true

  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.app_name}-osdisk1-${count.index + 1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  
    storage_data_disk {
    name              = "${var.app_name}-datadisk1-${count.index + 1}"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "500"
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

resource "azurerm_sql_firewall_rule" "dbrule" {
  count               = "${var.database_workspace == "" ? 0 : var.instance_count}"
  name                = "${var.app_name}-DBRule-${count.index}"
  resource_group_name = "${data.terraform_remote_state.databasedetails.db-rg}"
  server_name         = "${data.terraform_remote_state.databasedetails.databasename}"
  start_ip_address    = "${azurerm_network_interface.netint.*.private_ip_address[count.index]}"
  end_ip_address      = "${azurerm_network_interface.netint.*.private_ip_address[count.index]}"
}

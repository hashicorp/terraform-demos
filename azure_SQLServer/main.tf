# Copyright IBM Corp. 2018

provider "azurerm" {}

data "terraform_remote_state" "networkdetails" {
  backend = "atlas"

  config {
    name = "azc/${var.network_workspace}"
  }
}

resource "azurerm_resource_group" "resource_gp" {
  name     = "${var.app_name}-rg"
  location = "${data.terraform_remote_state.networkdetails.location}"
}

resource "azurerm_sql_server" "sqlserver" {
  name                         = "${var.app_name}"
  resource_group_name          = "${azurerm_resource_group.resource_gp.name}"
  location                     = "${data.terraform_remote_state.networkdetails.location}"
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
  name                = "sql-vnet-rule"
  resource_group_name = "${azurerm_resource_group.resource_gp.name}"
  server_name         = "${azurerm_sql_server.sqlserver.name}"
  subnet_id           = "${data.terraform_remote_state.networkdetails.dbsubnet}"
}

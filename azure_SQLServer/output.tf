# Copyright IBM Corp. 2018

output "databasename" {
  value = "${azurerm_sql_server.sqlserver.name}"
}

output "db-rg" {
  value = "${azurerm_resource_group.resource_gp.name}"
}

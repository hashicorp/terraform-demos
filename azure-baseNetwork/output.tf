# Copyright IBM Corp. 2018

output "mainsubnet" {
  value = "${azurerm_subnet.main.id}"
}

output "dbsubnet" {
  value = "${azurerm_subnet.dbsub.id}"
}

output "location" {
  value = "${azurerm_resource_group.resource_gp.location}"
}

# Copyright IBM Corp. 2018

output "aws_ip_addresses" {
    value = "${aws_instance.server.*.private_ip}"
}

output "azure_ip_addresses" {
    value = "${azurerm_network_interface.netint.*.private_ip_address}"
}


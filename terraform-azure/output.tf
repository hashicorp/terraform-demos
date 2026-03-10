# Copyright IBM Corp. 2018

output "private_ips" {
  value = "${azurerm_network_interface.netint.*.private_ip_address}"
}

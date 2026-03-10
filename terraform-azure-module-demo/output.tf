# Copyright IBM Corp. 2018

output "ip_addresses" {
    value = "${module.linuxservers.public_ip_address}"
}

output "network_interface_ids" {
    value = "${module.linuxservers.network_interface_ids}"
}
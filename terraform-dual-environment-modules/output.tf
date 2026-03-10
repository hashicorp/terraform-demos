# Copyright IBM Corp. 2018

output "azure_public_ip_addresses" {
    value = "${module.linuxservers.public_ip_address}"
}

output "aws_public_ip_addresses" {
  value = "${module.ec2.public_ip}"
}
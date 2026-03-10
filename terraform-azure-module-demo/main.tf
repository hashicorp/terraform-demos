# Copyright IBM Corp. 2018

  module "linuxservers" {
    source              = "Azure/compute/azurerm"
    location            = "${var.location}"
    vm_os_simple        = "UbuntuServer"
    vnet_subnet_id      = "${module.network.vnet_subnets[0]}"
    nb_instances        = 2
    delete_os_disk_on_termination = "true"
    public_ip_dns       = ["linvmip1","linvmip2"]
    resource_group_name = "azc-rg"
    nb_public_ip        = "2"
  }
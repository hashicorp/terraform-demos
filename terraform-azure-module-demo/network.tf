# Copyright IBM Corp. 2018

module "network" {
    source              = "Azure/network/azurerm"
    version             = "~> 1.1.1"
    location            = "${var.location}"
    allow_ssh_traffic   = "true"
    resource_group_name = "azc-rg"
  }


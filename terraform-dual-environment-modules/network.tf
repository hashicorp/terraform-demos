# Copyright IBM Corp. 2018

// Azure Environment

module "network" {
    source              = "Azure/network/azurerm"
    version             = "~> 1.1.1"
    location            = "${var.location}"
    allow_ssh_traffic   = "true"
    resource_group_name = "azc-rg"
  }


// AWS 
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-1a", "us-west-1c"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
    Owner = "Adam"
  }
}
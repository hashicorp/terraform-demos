# Copyright IBM Corp. 2018


// Azure Environment

module "linuxservers" {
    source              = "Azure/compute/azurerm"
    location            = "${var.location}"
    vm_os_simple        = "UbuntuServer"
    vnet_subnet_id      = "${module.network.vnet_subnets[0]}"
    nb_instances        = 2
    delete_os_disk_on_termination = "true"
    public_ip_address_allocation = "static"
    public_ip_dns       = ["linvmip1","linvmip2"]
    resource_group_name = "azc-rg"
    nb_public_ip        = "2"
    ssh_key = "pub.rsa"
  }

// AWS 

provider "aws" {
    region = "${var.aws_region}"
}

module "security_group" {
  source = "terraform-aws-modules/security-group/aws"
  
  name        = "demotonight"
  description = "Security group for example usage with EC2 instance"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp","ssh-tcp"]
  #ssh-tcp
  egress_rules        = ["all-all"]
  tags = {
    Name = "Adam"
  }
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "1.3.0"

  instance_count = 2
  name                        = "example"
  ami                         = "${var.ami_id}"
  instance_type               = "t2.micro"
  subnet_id                   = "${element(module.vpc.public_subnets, 0)}"
  vpc_security_group_ids = ["${module.security_group.this_security_group_id}"]
  associate_public_ip_address = true
  key_name = "acavaliere"
  tags = {
    Owner = "Adam"
    TTL = "5"
  }
}

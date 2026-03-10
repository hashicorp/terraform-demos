# Copyright IBM Corp. 2018

provider "aws" {
  region = "${var.aws_region}"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "VPC-${var.network_name}"
  cidr = "10.0.0.0/16"

  azs            = ["${var.aws_region}a", "${var.aws_region}c"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
    Owner       = "Adam"
  }
}

module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "Base-Secuirty-${var.network_name}"
  description = "Security Group"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_rules = ["http-80-tcp", "all-icmp", "ssh-tcp", "https-443-tcp"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 8800
      to_port     = 8800
      protocol    = "tcp"
      description = "PTFE Config Port"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  #ingress_rules = ["http-80-tcp", "all-icmp"]
  egress_rules = ["all-all"]

  tags = {
    Name        = "Adam"
    Environment = "${var.environment}"
  }
}

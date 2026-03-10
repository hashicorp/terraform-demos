# Copyright IBM Corp. 2018

provider "aws" {
    region = "${var.aws_region}"
}

module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "example"
  description = "Security group for example usage with EC2 instance"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp", "ssh-tcp"]
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


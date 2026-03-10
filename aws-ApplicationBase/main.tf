# Copyright IBM Corp. 2018

provider "aws" {
  region = "${data.terraform_remote_state.networkdetails.region}"
}

data "terraform_remote_state" "networkdetails" {
  backend = "atlas"

  config {
    name = "azc/${var.network_workspace}"
  }
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "1.3.0"

  instance_count              = 2
  name                        = "${var.application_name}-demo"
  ami                         = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${element(data.terraform_remote_state.networkdetails.public_subnets, 0)}"
  vpc_security_group_ids      = ["${data.terraform_remote_state.networkdetails.security_group}"]
  associate_public_ip_address = true
  key_name                    = "${var.key_name}"

  root_block_device = [{
    volume_size = "50"
  }]

  tags = {
    Owner = "${var.owner}"
    TTL   = "${var.ttl}"
  }
}

data "aws_route53_zone" "selected" {
  name = "${var.domain_root}."
}

resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.application_name}.${var.domain_root}"
  type    = "A"
  ttl     = "300"
  records = ["${element(module.ec2.public_ip, 0)}"]
}

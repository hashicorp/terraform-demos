# Copyright IBM Corp. 2018

output "public_subnets" {
  value = "${module.vpc.public_subnets}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "region" {
  value = "${var.aws_region}"
}

output "security_group" {
  value = "${module.security_group.this_security_group_id}"
}

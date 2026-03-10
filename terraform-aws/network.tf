# Copyright IBM Corp. 2018

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"

  tags {
    Name = "${var.app_name}-vpc-${var.networkEnv}"
    Owner = "${var.owner}"
  }
}

resource "aws_subnet" "sub" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = "${lookup(var.avail_zone, count.index)}"
  count = 2
  tags {
    Name = "${var.app_name}-subnet-${var.networkEnv}"
    Owner = "${var.owner}"
  }
}
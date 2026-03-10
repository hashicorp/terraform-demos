# Copyright IBM Corp. 2018

provider "aws" {
  region = "us-east-1"
}

//--------------------------------------------------------------------
// Modules
module "network" {
  source  = "app.terraform.io/azc/network/aws"
  version = "0.1.1"

  region                   = "us-east-1"
  subnet_availability_zone = "us-east-1a"
}

resource "aws_instance" "server" {
  ami           = "ami-04d93f8d139d78b9f"
  instance_type = "t2.micro"

  tags {
    Name = "Example Module Use"
  }

  subnet_id = "${module.network.demo_subnet_id}"
}

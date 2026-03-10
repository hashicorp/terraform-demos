# Copyright IBM Corp. 2018

# Azure Variables
variable "location" {
  description = "Resource location"
  default = "West US"
}

variable "ami_id" {
  description = "ID of the AMI to provision. Default is Ubuntu 14.04 Base Image"
  default = "ami-154f4a75"
}

variable "name" {
  description = "name to pass to Name tag"
  default = "Provisioned by Terraform"
}

variable "aws_region" {
  description = "AWS region"
  default = "us-west-1"
}

variable "app_name" {
    description = "Name of Application"
    default = "defaultapp"
}

variable "networkEnv" {
    description = "e.g. Dev, Stage, Prod"
    default = "dev"
}

variable "availability_zone" {
    description = "Availability zone for subnet"
    default = "us-west-1a"
}

variable "avail_zone" {
  default = {
      "0" = "us-west-1a"
      "1" = "us-west-1c"
  }
}
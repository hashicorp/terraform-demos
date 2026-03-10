# Copyright IBM Corp. 2018

variable "network_name" {
  description = "Name of the Network"
  default     = "notSet"
}

variable "environment" {
  description = "Environment Type - dev, stage, prod"
  default     = "notSet"
}

variable "aws_region" {
  description = "Region for network to be deployed"
  default     = "us-east-2"
}

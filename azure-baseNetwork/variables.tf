# Copyright IBM Corp. 2018

variable "app_name" {
    description = "Name of Application"
    default = "notSet"
}

variable "networkEnv" {
    description = "e.g. Dev, Stage, Prod"
    default = "notSet"
}

variable "location" {
  description = "Resource location"
  default = "West US"
}
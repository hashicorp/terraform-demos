# Copyright IBM Corp. 2018

variable "app_name" {
  description = "Name of Application"
  default     = "defaultapp"
}

variable "networkEnv" {
  description = "e.g. Dev, Stage, Prod"
  default     = "dev"
}

variable "location" {
  description = "Resource location"
  default     = "West US"
}

variable "instance_count" {
  description = "Number of servers"
  default     = "2"
}

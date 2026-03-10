# Copyright IBM Corp. 2018

variable "instance_count" {
  description = "number of VMs"
  default     = "2"
}

variable "network_workspace" {
  description = "Workspace to reference for network resources"
  default     = "mustBeSet"
}

variable "database_workspace" {
  description = "Workspace to reference for network resources"
  default     = ""
}

variable "app_name" {
  description = "application name"
  default     = "Not Set"
}

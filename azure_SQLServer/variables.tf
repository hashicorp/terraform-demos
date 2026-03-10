# Copyright IBM Corp. 2018

variable "app_name" {
  description = "Application Name"
  default     = "notSet"
}

variable "network_workspace" {
  description = "Network Workspace to attach Database to"
  default     = "mustBeSet"
}

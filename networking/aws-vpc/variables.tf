variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "costs_enabled" {
  type = bool
  description = "Are cost resources built?"
  default = false
}

locals {
  enable = var.costs_enabled == true ? 1 : 0
}
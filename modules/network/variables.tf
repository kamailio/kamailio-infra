variable "environment" {
  type = string
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "cidr" {
  description = "(Optional) The IPv4 CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

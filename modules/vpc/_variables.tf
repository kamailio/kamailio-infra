variable "main_cidr_block" {
  type        = string
  description = "VPC Network range"
}

variable "vpc_name" {
  type        = string
  default     = "Kamailio-build"
  description = "The name of the VPC to use for the deployment"
}

variable "environment" {
  type        = string
  description = "Environment name (development/production)"
}

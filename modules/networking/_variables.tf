variable "environment" {
  type        = string
  description = "Environment name (development/production)"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the subnet"
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "The VPC id"
}

variable "route_table_id" {
  type        = string
  default     = ""
  description = "The route table id"
}

variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "AWS region to use"
}

## Specifying the availability zone to use for storage
variable "availability_zone" {
  type        = string
  default     = "eu-west-1b"
  description = "Availability zone for EBS volume"
}


variable "environment" {
  type        = string
  default     = "development"
  description = "Envirnoment name"
}

## VPC details
variable "vpc_name" {
  type        = string
  default     = "kamailio-development-vpc"
  description = "The name of the VPC to use for the deployment"
}

variable "main_cidr_block" {
  type        = string
  default     = "172.10.0.0/16"
  description = "VPC Network range"
}

## Subnet
variable "cidr_block" {
  type        = string
  default     = "172.10.10.0/24"
  description = "Envirnoment IP block range"
}

## Storage/Volume
variable "packages_disk_volume" {
  type        = number
  default     = 15
  description = "Disk volume size in GB to store packages"
}

## VM details
variable "ami" {
  type        = string
  default     = "ami-0c9e5f4bbf9701d5d"
  description = "AMI to use"
}
variable "instance_type" {
  type        = string
  default     = "t1.micro"
  description = "Envirnoment instance type"
}

## Access keys
variable "initial_ssh_key_name" {
  type        = string
  default     = "aws_ie-1"
  description = "Initial ssh key name to be used to access the instances"
}

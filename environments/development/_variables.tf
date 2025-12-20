variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS region to use"
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

variable "jenkins_disk_volume" {
  type        = number
  default     = 25
  description = "Disk volume size in GB to store jenkins jobs and workspaces"
}

## VM details
variable "ami" {
  type        = string
  default     = "ami-050edffb813a5d593"
  description = "AMI to use"
}
variable "instance_type" {
  type        = string
  default     = "t2.medium"
  description = "Envirnoment instance type"
}

## Access keys
variable "initial_ssh_key_name" {
  type        = string
  default     = "vseva-key"
  description = "Initial ssh key name to be used to access the instances"
}

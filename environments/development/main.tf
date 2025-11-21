terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "kamailio-build-env-state"
    key            = "development/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "kamailio-build-env-locks"
    encrypt        = true
  }
}

## Create VPC
module "vpc" {
  source          = "./../../modules/vpc"
  vpc_name        = var.vpc_name
  main_cidr_block = var.main_cidr_block
  environment     = var.environment
}

# Create Environment networks
module "networking" {
  source = "./../../modules/networking"

  vpc_id         = module.vpc.vpc_id
  environment    = var.environment
  cidr_block     = var.cidr_block
  route_table_id = module.vpc.route_table_id
}

resource "aws_key_pair" "vseva" {
  key_name   = "vseva-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEfAU3uyA2auccZt0wn9OWWxGYLttOaagDVJh4VtfPO6"
}

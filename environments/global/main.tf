terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

resource "aws_key_pair" "vseva" {
  key_name   = "vseva-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEfAU3uyA2auccZt0wn9OWWxGYLttOaagDVJh4VtfPO6"
}

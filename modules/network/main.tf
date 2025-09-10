module "network" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "0.0.1"

  name = "${var.name}-${var.environment}-vpc"
  cidr = var.cidr
  azs  = ["eu-central-1"]

  enable_nat_gateway         = true
  enable_dns_hostnames       = true
  manage_default_network_acl = false

  tags = {
    Environment = var.environment
  }
}


resource "aws_security_group" "ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = module.network.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

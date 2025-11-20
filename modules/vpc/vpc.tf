resource "aws_vpc" "kamailio-build" {
  cidr_block           = var.main_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = var.vpc_name
    Environment = var.environment
    Build_id    = "kama-build"
  }
}

resource "aws_internet_gateway" "kamailio-build" {
  vpc_id = aws_vpc.kamailio-build.id

  tags = {
    Name        = "${var.vpc_name}-igw"
    Environment = var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.kamailio-build.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kamailio-build.id
  }

  tags = {
    Name        = "${var.vpc_name}-public-rt"
    Environment = var.environment
    Build_id    = "kama-build"
  }
}

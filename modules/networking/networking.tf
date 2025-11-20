resource "aws_subnet" "subnets" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-subnet"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "environment" {
  subnet_id      = aws_subnet.subnets.id
  route_table_id = var.route_table_id
}

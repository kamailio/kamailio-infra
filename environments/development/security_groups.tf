resource "aws_security_group" "development" {
  name_prefix = "${var.environment}-env-"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name        = "Kamailio-${var.environment}-security-group"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  web_allowed_cidrs = ["0.0.0.0/0"]
  ssh_allowed_cidrs = ["0.0.0.0/0"]
}

## Inbound traffic
resource "aws_security_group_rule" "inbound_web_443" {
  type              = "ingress"
  security_group_id = aws_security_group.development.id

  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = local.web_allowed_cidrs

}

resource "aws_security_group_rule" "inbound_web_80" {
  type              = "ingress"
  security_group_id = aws_security_group.development.id

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = local.web_allowed_cidrs

}

resource "aws_security_group_rule" "ssh_22" {
  type              = "ingress"
  security_group_id = aws_security_group.development.id

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = local.ssh_allowed_cidrs

}

## Outbound traffic

resource "aws_security_group_rule" "outbound_allow_all" {
  type              = "egress"
  security_group_id = aws_security_group.development.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

}

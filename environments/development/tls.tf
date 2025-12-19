resource "tls_private_key" "admin_development" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "admin_development" {
  content  = tls_private_key.admin_development.private_key_pem
  filename = "./keys/admin_${var.environment}.pem"
}

resource "local_file" "admin_development_pub" {
  content  = tls_private_key.admin_development.public_key_pem
  filename = "./keys/admin_${var.environment}.pub"
}

resource "aws_key_pair" "admin_development" {
  key_name   = "admin_${var.environment}"
  public_key = tls_private_key.admin_development.public_key_openssh
  tags = {
    Environment       = var.environment
    "Creation_Method" = "Terraform"
  }
}

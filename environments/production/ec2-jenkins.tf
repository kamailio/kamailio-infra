resource "aws_instance" "jenkins" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = module.networking.subnet_id
  availability_zone      = data.aws_availability_zones.available.names[1]
  vpc_security_group_ids = [aws_security_group.production.id]
  key_name               = var.initial_ssh_key_name
  ## Used for testing
  user_data = <<-EOF
                #!/usr/bin/bash
                curl -fsSL https://get.docker.com -o get-docker.sh
                sh get-docker.sh
                docker run -d -p 80:80 --name iamfoo traefik/whoami
                EOF
  ##

  tags = {
    Name        = "Jenkins-${var.environment}-instance"
    Environment = var.environment
  }
}

# Attach package storage volume to instance
resource "aws_volume_attachment" "package_volume_to_instance" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.package_volume.id
  instance_id = aws_instance.jenkins.id
  depends_on  = [aws_instance.jenkins]
}

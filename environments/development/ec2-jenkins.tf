locals {
  jenkins_master_servername = data.sops_file.secrets.data["jenkins_master_servername"]
}

resource "aws_instance" "jenkins" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = module.networking.subnet_id
  availability_zone           = data.aws_availability_zones.available.names[1]
  vpc_security_group_ids      = [aws_security_group.development.id]
  iam_instance_profile        = aws_iam_instance_profile.jenkins.name
  key_name                    = var.initial_ssh_key_name
  user_data                   = <<-EOF
    #!/bin/bash
    echo "starting user_data at $(date)"
    rm /etc/nginx/sites-enabled/${local.jenkins_master_servername}.conf
    echo "remove nginx ${local.jenkins_master_servername} config"
    rm -rf /etc/letsencrypt/live
    echo "removed /etc/letsencrypt/live"
    echo "*** remote ansible execution needed ***"
    echo "done user_data at $(date)"
  EOF
  user_data_replace_on_change = true

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

resource "aws_eip" "jenkins" {
  instance   = aws_instance.jenkins.id
  domain     = "vpc"
  depends_on = [aws_instance.jenkins]

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "Jenkins-${var.environment}-ip"
    Environment = var.environment
  }
}

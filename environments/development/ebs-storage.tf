# Create block storage
resource "aws_ebs_volume" "package_volume" {
  availability_zone = data.aws_availability_zones.available.names[1]
  size              = var.packages_disk_volume

  tags = {
    Name        = "${var.environment}-package_volume"
    Environment = var.environment
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_ebs_volume" "jenkins_volume" {
  availability_zone = data.aws_availability_zones.available.names[1]
  size              = var.jenkins_disk_volume

  tags = {
    Name        = "${var.environment}-jenkins_volume"
    Environment = var.environment
  }
  lifecycle {
    prevent_destroy = true
  }
}

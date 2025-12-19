output "jenkins-public-ips" {
  value       = aws_instance.jenkins.public_ip
  description = "Jenkins public IP"
}

output "jenkins_master_ec2_subnet_id" {
  value       = module.networking.subnet_id
  description = "subnet_id"
}

output "public_key_openssh" {
  value       = tls_private_key.admin_development.public_key_openssh
  description = "public_key_openssh"
}

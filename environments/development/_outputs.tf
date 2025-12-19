output "jenkins-public-ips" {
  value       = aws_instance.jenkins.public_ip
  description = "Jenkins public IP"
}

output "jenkins_master_ec2_subnet_id" {
  value       = module.networking.subnet_id
  description = "subnet_id"
}

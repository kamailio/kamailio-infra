output "jenkins-public-ips" {
  value       = aws_instance.jenkins.public_ip
  description = "Jenkins public IP"
}

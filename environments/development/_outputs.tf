output "jenkins-public-ips" {
  value       = [for instance in aws_instance.jenkins : instance.public_ip]
  description = "Jenkins public IP"
}

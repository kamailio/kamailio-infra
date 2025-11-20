output "subnet_id" {
  description = "ID of the created subnet"
  value       = aws_subnet.subnets.id
}

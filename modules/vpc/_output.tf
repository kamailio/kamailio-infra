output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.kamailio-build.id
}

output "route_table_id" {
  value       = aws_route_table.public.id
  description = "VPC routing table id"
}

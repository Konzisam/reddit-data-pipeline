output "vpc_id" {
  description = "vpc id"
  value       = aws_vpc.prod-vpc.id
}

output "subnet_id" {
  description = "subnet id"
  value       = aws_subnet.subnet-1.id
}

output "route_table_id" {
  description = "route table id"
  value       = aws_route_table.prod-route-table.id
}

output "internet_gateway" {
  description = "IGW id"
  value       = aws_internet_gateway.gw
}

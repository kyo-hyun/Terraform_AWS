output "get_subnet_id" {
    value = { for k, v in aws_subnet.subnet : k => v.id }
}

output "get_vpc_id" {
    value = aws_vpc.vpc.id
}
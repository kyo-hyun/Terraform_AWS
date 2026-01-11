output "get_subnet_id" {
    value = { for k, v in aws_subnet.test_subnet : k => v.id }
}

output "get_vpc_id" {
    value = aws_vpc.test_vpc.id
}
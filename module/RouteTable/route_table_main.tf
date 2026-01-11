# route table
resource "aws_route_table" "test_route_table" {
  vpc_id = var.vpc_id

  dynamic route {
    for_each = {for route in var.routes : route.route_key => route}
    content {
      cidr_block = route.value.destination
      gateway_id = route.value.target
    }
  }

  tags = { 
    Name = var.name
  }
}

# route table attach subent
resource "aws_route_table_association" "test_rt_assoc" {
  for_each       = var.subnet_ids
  subnet_id      = each.value
  route_table_id = aws_route_table.test_route_table.id
}
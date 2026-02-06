# route table
resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  dynamic route {
    for_each = {for route in var.routes : route.route_key => route}
    content {
      cidr_block      = route.value.destination
      gateway_id      = lookup(route.value,"target",null)
      vpc_endpoint_id = lookup(route.value,"vpc_endpoint",null)
    }
  }

  tags = { 
    Name = var.name
  }
}

# route table subnet attach subent
resource "aws_route_table_association" "rt_subnet_assoc" {
  for_each       = var.subnet_ids
  subnet_id      = each.value
  route_table_id = aws_route_table.route_table.id
}

# route table gateway attach subent
resource "aws_route_table_association" "rt_gateway_assoc" {
  count          = var.edge_name != null ? 1 : 0
  gateway_id     = var.edge_id
  route_table_id = aws_route_table.route_table.id
}
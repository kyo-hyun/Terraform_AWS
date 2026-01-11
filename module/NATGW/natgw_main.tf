#natgw
resource "aws_nat_gateway" "test_natgw" {
  allocation_id = var.eip_id
  subnet_id     = var.subnet_id

  tags = {
    Name = var.name
  }

}
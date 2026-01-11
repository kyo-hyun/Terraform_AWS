# igw
resource "aws_internet_gateway" "test_igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.name
  }
}
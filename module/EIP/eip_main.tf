# eip
resource "aws_eip" "testeip" {

  tags = {
    Name = "${var.name}"
  }
}
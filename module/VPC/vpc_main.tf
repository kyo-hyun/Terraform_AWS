# vpc
resource "aws_vpc" "test_vpc" {
    cidr_block = var.cidr_block
    tags = {
        Name = "${var.name}"
    }
}

# subnet
resource "aws_subnet" "test_subnet" {
    for_each = var.subnet
    vpc_id = aws_vpc.test_vpc.id
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone
    map_public_ip_on_launch = each.value.map_public_ip_on_launch

    tags = {

        Name = "${each.key}"

    } 
}
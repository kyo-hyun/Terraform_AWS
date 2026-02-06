# vpc
resource "aws_vpc" "vpc" {
    cidr_block = var.cidr_block
    tags = {
        Name = "${var.name}"
    }
}

# subnet
resource "aws_subnet" "subnet" {
    for_each = var.subnet
    vpc_id = aws_vpc.vpc.id
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone
    map_public_ip_on_launch = lookup(each.value,"map_public_ip_on_launch",false)

    tags = {
        Name = "${each.key}"
    }
}
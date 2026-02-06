locals {
  # 1. 중첩된 구조를 리스트로 펼치기 (Flatten)
  raw_routes = flatten([
    for rt_key, rt_data in var.route_table : [
      for route in rt_data.route : {
        rt_key           = rt_key
        destination_cidr = route.destination_cidr_block
        target_vpc       = route.destination_vpc
      }
    ]
  ])

  # 2. for_each에 쓸 수 있도록 고유한 Key를 가진 맵으로 변환
  static_routes = {
    for r in local.raw_routes : "${r.rt_key}_${r.destination_cidr}" => r
  }
}

# Transit Gateway 생성
resource "aws_ec2_transit_gateway" "tgw" {
  amazon_side_asn                 = var.amazon_side_asn
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "enable"

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

# VPC Attachments 생성
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attac_vpc" {
  for_each           = var.vpc_connections

  subnet_ids         = each.value.subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = each.value.vpc_id

  tags = {
    #Name = "${var.tgw_config.name}-attach-${each.key}"
  }
}

resource "aws_ec2_transit_gateway_route_table" "tgw_rt" {
  for_each = var.route_table
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name = each.key
  }
}

# Route Table Association (VPC Attachment를 특정 RT에 연결)
resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_assoc" {
  for_each = var.vpc_connections
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attac_vpc[each.key].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt[each.value.route_table].id
}

# 정적 경로 생성
resource "aws_ec2_transit_gateway_route" "static" {
  for_each = local.static_routes
  destination_cidr_block         = each.value.destination_cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt[each.value.rt_key].id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attac_vpc[each.value.target_vpc].id
}
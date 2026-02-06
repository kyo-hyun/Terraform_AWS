resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  for_each          = toset(var.cidr_ipv4)
  security_group_id = var.security_group_id
  cidr_ipv4         = each.key
  from_port         = var.from_port
  ip_protocol       = var.ip_protocol
  to_port           = var.to_port
  tags = {
    Name            = var.name
  }
}
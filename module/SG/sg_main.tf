resource "aws_security_group" "allow_ssh" {
  name        = var.name
  vpc_id      = var.vpcid

  tags = {
    Name = var.name
  }
}

module "ingress_rule" {
  source            = "./module/ingress_rule"
  for_each          = var.ingress_rule
  name              = each.key
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = each.value.cidr_ipv4
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.ip_protocol
}

module "egress_rule" {
  source            = "./module/egress_rule"
  for_each          = var.egress_rule == null ? {} : var.egress_rule
  name              = each.key
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = each.value.cidr_ipv4
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.ip_protocol
}
resource "aws_lb" "Loadbalancer"{
  name                = var.name
  internal            = var.internal
  load_balancer_type  = var.load_balancer_type
  security_groups     = var.security_groups
  subnets             = var.subnets
  tags = {
      Name = var.name
  }
}

# NLB
resource "aws_lb_listener" "nlb_listener" {
  for_each            = {for nlb_listener in var.nlb_listener : nlb_listener.listener => nlb_listener if var.load_balancer_type == "network"}
  load_balancer_arn   = aws_lb.Loadbalancer.arn
  port                = each.value.port
  protocol            = each.value.protocol

  default_action {
    type              = each.value.action
    target_group_arn  = each.value.default_target
  }
}
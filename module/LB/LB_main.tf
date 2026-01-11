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

# ALB
resource "aws_lb_listener" "front_end" {
  for_each            = var.load_balancer_type == "application" ? var.alb_listener : {}
  load_balancer_arn   = aws_lb.Loadbalancer.arn
  port                = each.value.port    
  protocol            = each.value.protocol
  certificate_arn     = var.certificate_arn

  default_action {
    type             = each.value.action

    forward {
      dynamic target_group {
        for_each  = {for target_group in var.default_target_group : target_group.target_group => target_group}
        content {
          arn       = target_group.value.tg_arn
          weight    = target_group.value.weight
        }
      }
    }
  }
}

resource "aws_lb_listener_rule" "url1_rule" {
  for_each            = {for rule_key, rule_value in var.rule : rule_value.rule => rule_value if var.load_balancer_type == "application"}
  listener_arn        = aws_lb_listener.front_end[each.value.listener].arn
  priority            = each.value.priority

  action {
    type              = each.value.action_type
    target_group_arn  = each.value.target_group
  }

  condition {
    path_pattern {
      values = [each.value.path]
    }
  }
}
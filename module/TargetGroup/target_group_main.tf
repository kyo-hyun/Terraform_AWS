resource "aws_lb_target_group" "test" {
  name     = var.name
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id

  health_check {
    path = var.path
    #protocol = var.protocol
  }
}

resource "aws_alb_target_group_attachment" "attach_ec2" {
  for_each         = var.ec2_id
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = each.value
  port             = var.port
}
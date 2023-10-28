resource "aws_alb" "alb" {
  name               = var.name
  load_balancer_type = "application"
  subnets = var.subnet_ids
  security_groups = [var.security_group_id]
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = var.listener_target_group_arn
  }
  tags = {
    Name = "tay-tay-client-alb-listener"
  }
}
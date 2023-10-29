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
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }

  tags = {
    Name = "tay-tay-client-alb-listener"
  }
}

resource "aws_alb_listener_rule" "listener_rules" {
  count = length(var.path_target_map)

  listener_arn = aws_lb_listener.alb_listener.arn

  action {
    type             = "forward"
    target_group_arn = element(values(var.path_target_map), count.index)
  }

  condition {
    path_pattern {
      values = [element(keys(var.path_target_map), count.index)]
    }
  }
}
resource "aws_alb" "alb" {
  name               = var.name
  load_balancer_type = "application"
  subnets = var.subnet_ids
  security_groups = [var.security_group_id]
}

variable "root_domain_name" {
  type    = string
  default = "taytay.me"
}

resource "aws_acm_certificate" "tay_tay_me_certificate" {
  domain_name       = var.root_domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.tay_tay_me_certificate.arn

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
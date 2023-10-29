output "services_security_group_id" {
  value = aws_security_group.services_security_group.id
}

output "alb_security_group_arn" {
  value = aws_security_group.alb_security_group.arn
}

output "alb_security_group_id" {
  value = aws_security_group.alb_security_group.id
}

output "alb_target_group_arn_client" {
  value = aws_lb_target_group.alb_target_group_client.arn
}

output "alb_target_group_arn_server" {
  value = aws_lb_target_group.alb_target_group_server.arn
}

output "subnet_ids" {
  value = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id, aws_subnet.subnet_c.id]
}
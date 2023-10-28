output "alb_arn" {
  value = aws_alb.alb.arn
}

output "dns_alb" {
    value = aws_alb.alb.dns_name
}
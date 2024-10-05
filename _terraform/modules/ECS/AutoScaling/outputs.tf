output "appautoscaling_target_min_capacity" {
  value = aws_appautoscaling_target.appautoscaling_target.min_capacity
}

output "appautoscaling_target_max_capacity" {
  value = aws_appautoscaling_target.appautoscaling_target.max_capacity
}
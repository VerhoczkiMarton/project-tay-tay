output "arn_task_definition" {
  value = aws_ecs_task_definition.ecs_task.arn
}

output "task_definition_family" {
  value = aws_ecs_task_definition.ecs_task.family
}

output "task_definition_revision" {
  value = aws_ecs_task_definition.ecs_task.revision
}

output "task_definitions" {
  value = aws_ecs_task_definition.ecs_task.container_definitions
}
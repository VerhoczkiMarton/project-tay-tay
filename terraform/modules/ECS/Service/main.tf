resource "aws_ecs_service" "ecs_service" {
  name             = var.name
  cluster          = var.ecs_cluster_id
  task_definition  = var.arn_task_definition
  desired_count    = var.desired_tasks
  enable_execute_command = true
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  load_balancer {
    target_group_arn = var.arn_target_group
    container_name   = var.container_name
    container_port   = var.container_port
  }
  network_configuration {
    assign_public_ip = true
    subnets          = var.subnets
    security_groups  = [var.security_group_id]
  }
  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }
}
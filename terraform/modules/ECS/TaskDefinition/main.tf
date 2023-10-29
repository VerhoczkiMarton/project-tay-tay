resource "aws_ecs_task_definition" "ecs_task" {
  family                = var.name
  network_mode          = "awsvpc"
  memory                = var.memory
  cpu                   = var.cpu
  execution_role_arn    = aws_iam_role.ecsTaskExecutionRole.arn
  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.container_name}",
      "image": "${var.docker_repository}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": ${var.container_port},
          "hostPort": ${var.container_port}
        }
      ],
      "memory": ${var.memory},
      "cpu": ${var.cpu}
    }
  ]
  DEFINITION
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${var.name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "TaskDF-Log_Group" {
  name              = "/ecs/task-definition-${var.name}"
  retention_in_days = 30
}
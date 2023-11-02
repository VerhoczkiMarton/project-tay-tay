resource "aws_ecs_task_definition" "ecs_task" {
  family                = var.name
  network_mode          = "awsvpc"
  memory                = var.memory
  cpu                   = var.cpu
  execution_role_arn    = aws_iam_role.ecs_execution_role.arn
  task_role_arn         = aws_iam_role.ecs_task_role.arn
  container_definitions = <<-DEFINITION
  [
    {
      "name": "${var.container_name}",
      "image": "${var.docker_repository}",
      "essential": true,
      "memory": ${var.memory},
      "cpu": ${var.cpu},
      "environment": [
        {
          "name": "ECS_ENABLE_METADATA",
          "value": "true"
        }
      ],
      "log_configuration": [
        {
          "log_driver": "awslogs",
          "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.cloudwatch_log_group_ecs_tasks.name}",
            "awslogs-region": "eu-central-1"
          }
        }
      ],
      "portMappings": [
        {
          "containerPort": ${var.container_port},
          "hostPort": ${var.container_port}
        }
      ]
    }
  ]
  DEFINITION
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group_ecs_tasks" {
  name              = "/ecs/task-definition-${var.name}"
  retention_in_days = 7
}

resource "aws_iam_role" "ecs_execution_role" {
  name               = "${var.name}_execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_execution_assume_role_policy.json
}

data "aws_iam_policy_document" "ecs_execution_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.name}_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "secrets_manager_policy" {
  name = "${var.name}_secrets_manager_policy"
  description = "Policy for Secrets Manager access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "secrets_manager_access" {
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
  role       = aws_iam_role.ecs_task_role.name
}

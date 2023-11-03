resource "aws_ecs_task_definition" "ecs_task" {
  family                = var.name
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
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
      "secrets": [
        {
          "name": "SPRING_DATASOURCE_PASSWORD",
          "valueFrom": "${var.database_secret_arn}"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "tay-tay-ecs-logs",
            "awslogs-region": "eu-central-1",
            "awslogs-create-group": "true",
            "awslogs-stream-prefix": "tay-tay"
        }
      },
      "portMappings": [
        {
          "containerPort": ${var.container_port},
          "hostPort": ${var.container_port}
        }
      ],
      "healthCheck": {
        "command": [
          "CMD-SHELL",
          "curl -f http://localhost:${var.container_port}${var.health_check_path} || exit 1"
        ],
        "interval": 15,
        "timeout": 10,
        "retries": 5,
        "startPeriod": 120
      }
    }
  ]
  DEFINITION
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

resource "aws_iam_policy" "ssm_policy" {
  name   = "${var.name}_ssm_policy"
  description = "Policy for SSM access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:CreateControlChannel"
        ],
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "logs_policy" {
  name   = "${var.name}_logs_policy"
  description = "Policy for CloudWatch Logs access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:*"
        ],
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "task_role_secrets_manager_access" {
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
  role       = aws_iam_role.ecs_task_role.name
}

resource "aws_iam_role_policy_attachment" "execution_role_secrets_manager_access" {
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
  role       = aws_iam_role.ecs_execution_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_access" {
  policy_arn = aws_iam_policy.ssm_policy.arn
  role       = aws_iam_role.ecs_task_role.name
}

resource "aws_iam_role_policy_attachment" "task_role_logs_access" {
  policy_arn = aws_iam_policy.logs_policy.arn
  role       = aws_iam_role.ecs_task_role.name
}

resource "aws_iam_role_policy_attachment" "execution_role_logs_access" {
  policy_arn = aws_iam_policy.logs_policy.arn
  role       = aws_iam_role.ecs_execution_role.name
}
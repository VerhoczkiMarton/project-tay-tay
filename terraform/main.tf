provider "aws" {
  region = var.aws_region
}

resource "aws_ecr_repository" "tay_tay_ecr_repository_client" {
  name = "tay-tay-ecr-repository-client"
}

resource "aws_ecs_cluster" "tay_tay_ecs_cluster" {
  name = "tay-tay-ecs-cluster"
}

resource "aws_ecs_task_definition" "tay_tay_ecs_task_client" {
  family                = "tay-tay-ecs-container-client"
  network_mode          = "awsvpc"
  memory                = 512
  cpu                   = 256
  execution_role_arn    = aws_iam_role.ecsTaskExecutionRole.arn
  container_definitions = <<DEFINITION
  [
    {
      "name": "tay-tay-client-container",
      "image": "${aws_ecr_repository.tay_tay_ecr_repository_client.repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 5173,
          "hostPort": 5173
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "tay-tay-ecs-task-execution-role"
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

resource "aws_ecs_service" "tay_tay_ecs_service_client" {
  name             = "tay-tay-ecs-service-client"
  cluster          = aws_ecs_cluster.tay_tay_ecs_cluster.id
  task_definition  = aws_ecs_task_definition.tay_tay_ecs_task_client.arn
  desired_count    = 1

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 2
  }
  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.tay_tay_client_alb_target_group.arn
    container_name   = "tay-tay-client-container"
    container_port   = 5173
  }
  network_configuration {
    subnets          = [aws_subnet.tay_tay_subnet_a.id, aws_subnet.tay_tay_subnet_b.id, aws_subnet.tay_tay_subnet_c.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.tay_tay_client_service_security_group.id]
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_security_group" "tay_tay_client_service_security_group" {
  name   = "tay-tay-client-service-security-group"
  vpc_id = aws_vpc.tay_tay_vpc.id
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.tay_tay_alb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc" "tay_tay_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "tay-tay-vpc"
  }
}

resource "aws_internet_gateway" "tay_tay_internet_gateway" {
  vpc_id = aws_vpc.tay_tay_vpc.id
  tags = {
    Name = "tay-tay-internet-gateway"
  }
}

resource "aws_route" "tay_tay_subnet_a_route_to_internet" {
  route_table_id         = aws_vpc.tay_tay_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tay_tay_internet_gateway.id
}

resource "aws_subnet" "tay_tay_subnet_a" {
  availability_zone       = "${var.aws_region}a"
  vpc_id                  = aws_vpc.tay_tay_vpc.id
  cidr_block              = "10.0.0.0/18"
  map_public_ip_on_launch = true
  tags = {
    Name = "tay-tay-subnet-a"
  }
}

resource "aws_route_table_association" "tay_tay_subnet_association_a" {
  subnet_id      = aws_subnet.tay_tay_subnet_a.id
  route_table_id = aws_vpc.tay_tay_vpc.main_route_table_id
}

resource "aws_subnet" "tay_tay_subnet_b" {
  availability_zone       = "${var.aws_region}b"
  vpc_id                  = aws_vpc.tay_tay_vpc.id
  cidr_block              = "10.0.64.0/18"
  map_public_ip_on_launch = true
  tags = {
    Name = "tay-tay-subnet-b"
  }
}

resource "aws_route_table_association" "tay_tay_subnet_association_b" {
  subnet_id      = aws_subnet.tay_tay_subnet_b.id
  route_table_id = aws_vpc.tay_tay_vpc.main_route_table_id
}

resource "aws_subnet" "tay_tay_subnet_c" {
  availability_zone       = "${var.aws_region}c"
  vpc_id                  = aws_vpc.tay_tay_vpc.id
  cidr_block              = "10.0.128.0/18"
  map_public_ip_on_launch = true
  tags = {
    Name = "tay-tay-subnet-c"
  }
}

resource "aws_route_table_association" "tay_tay_subnet_association_c" {
  subnet_id      = aws_subnet.tay_tay_subnet_c.id
  route_table_id = aws_vpc.tay_tay_vpc.main_route_table_id
}

#resource "aws_security_group" "tay_tay_vpc_security_group" {
#  name   = "tay-tay-vpc-security-group"
#  vpc_id = aws_vpc.tay_tay_vpc.id
#}
#
#resource "aws_security_group_rule" "tay_tay_vpc_security_group_allow_outbound" {
#  type              = "egress"
#  from_port         = 0
#  to_port           = 0
#  protocol          = "-1"
#  security_group_id = aws_security_group.tay_tay_vpc_security_group.id
#  cidr_blocks       = ["0.0.0.0/0"]
#}
#
#resource "aws_eip" "tay_tay_eip" {
#  count = 3
#  tags = {
#    Name = "tay-tay-eip-${count.index}"
#  }
#}

resource "aws_alb" "tay_tay_alb" {
  name               = "tay-tay-alb"
  load_balancer_type = "application"
  subnets = [
    aws_subnet.tay_tay_subnet_a.id,
    aws_subnet.tay_tay_subnet_b.id,
    aws_subnet.tay_tay_subnet_c.id
  ]
  security_groups = [aws_security_group.tay_tay_alb_security_group.id]
}

resource "aws_security_group" "tay_tay_alb_security_group" {
  name   = "tay-tay-alb-security-group"
  vpc_id = aws_vpc.tay_tay_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "tay_tay_client_alb_target_group" {
  name        = "tay-tay-client-alb-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.tay_tay_vpc.id
  health_check {
    matcher = "200,301,302"
    path    = "/"
  }
}

resource "aws_lb_listener" "tay_tay_client_alb_listener" {
  load_balancer_arn = aws_alb.tay_tay_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tay_tay_client_alb_target_group.arn
  }
  tags = {
    Name = "tay-tay-client-alb-listener"
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_ecr_repository" "tay_tay_ecr_repository_client" {
  name = var.client_ecr_repository
}

resource "aws_ecs_cluster" "tay_tay_ecs_cluster" {
  name = var.ecs_cluster
}

resource "aws_ecs_task_definition" "tay_tay_ecs_task_client" {
  family                   = var.client_ecs_task_definition_family
  container_definitions    = <<DEFINITION
  [
    {
      "name": "${var.client_container_name}",
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
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
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
  name            = var.client_ecs_service
  cluster         = aws_ecs_cluster.tay_tay_ecs_cluster.id
  task_definition = aws_ecs_task_definition.tay_tay_ecs_task_client.arn
  launch_type     = "FARGATE"
  platform_version = "1.3.0"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.tay_tay_client_alb_target_group.arn
    container_name   = var.client_container_name
    container_port   = 5173
  }

  network_configuration {
    subnets          = [aws_subnet.tay_tay_subnet_a.id, aws_subnet.tay_tay_subnet_b.id, aws_subnet.tay_tay_subnet_c.id]
    assign_public_ip = true
    security_groups = [aws_security_group.tay_tay_client_service_security_group.id]
  }
}

resource "aws_security_group" "tay_tay_client_service_security_group" {
  vpc_id = aws_vpc.tay_tay_vpc.id
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
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
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "tay_tay_internet_gateway" {
  vpc_id = aws_vpc.tay_tay_vpc.id
}

resource "aws_route" "tay_tay_subnet_a_route_to_internet" {
  route_table_id         = aws_vpc.tay_tay_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tay_tay_internet_gateway.id
}

resource "aws_subnet" "tay_tay_subnet_a" {
  availability_zone = "${var.aws_region}a"
  vpc_id            = aws_vpc.tay_tay_vpc.id
  cidr_block        = "10.0.0.0/18"
}

resource "aws_route_table_association" "tay_tay_subnet_association_a" {
  subnet_id      = aws_subnet.tay_tay_subnet_a.id
  route_table_id = aws_vpc.tay_tay_vpc.main_route_table_id
}

resource "aws_subnet" "tay_tay_subnet_b" {
  availability_zone = "${var.aws_region}b"
  vpc_id            = aws_vpc.tay_tay_vpc.id
  cidr_block        = "10.0.64.0/18"
}

resource "aws_route_table_association" "tay_tay_subnet_association_b" {
  subnet_id      = aws_subnet.tay_tay_subnet_b.id
  route_table_id = aws_vpc.tay_tay_vpc.main_route_table_id
}

resource "aws_subnet" "tay_tay_subnet_c" {
  availability_zone = "${var.aws_region}c"
  vpc_id            = aws_vpc.tay_tay_vpc.id
  cidr_block        = "10.0.128.0/18"
}

resource "aws_route_table_association" "tay_tay_subnet_association_c" {
  subnet_id      = aws_subnet.tay_tay_subnet_c.id
  route_table_id = aws_vpc.tay_tay_vpc.main_route_table_id
}


resource "aws_security_group" "tay_tay_nat_security_group" {
  vpc_id = aws_vpc.tay_tay_vpc.id
  name_prefix = "tay-tay-nat-security-group"
}

resource "aws_security_group_rule" "tay_tay_nat_security_group_allow_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  security_group_id = aws_security_group.tay_tay_nat_security_group.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_eip" "tay_tay_nat_eip" {
  count = 3
}

# Create a NAT Gateway in each subnet
resource "aws_nat_gateway" "tay_tay_nat" {
  count = 3
  allocation_id = aws_eip.tay_tay_nat_eip[count.index].id
  subnet_id    = element([aws_subnet.tay_tay_subnet_a.id, aws_subnet.tay_tay_subnet_b.id, aws_subnet.tay_tay_subnet_c.id], count.index)
}

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
    path = "/"
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
}
# --- General networking ---
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "tay-tay-vpc"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "tay-tay-internet-gateway"
  }
}

resource "aws_route" "tay_tay_subnet_a_route_to_internet" {
  route_table_id         = aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_subnet" "subnet_a" {
  availability_zone       = "${var.aws_region}a"
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.0.0/18"
  map_public_ip_on_launch = true
  tags = {
    Name = "tay-tay-subnet-a"
  }
}

resource "aws_route_table_association" "subnet_association_a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_vpc.vpc.main_route_table_id
}

resource "aws_subnet" "subnet_b" {
  availability_zone       = "${var.aws_region}b"
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.64.0/18"
  map_public_ip_on_launch = true
  tags = {
    Name = "tay-tay-subnet-b"
  }
}

resource "aws_route_table_association" "subnet_association_b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_vpc.vpc.main_route_table_id
}

resource "aws_subnet" "subnet_c" {
  availability_zone       = "${var.aws_region}c"
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.128.0/18"
  map_public_ip_on_launch = true
  tags = {
    Name = "tay-tay-subnet-c"
  }
}

resource "aws_route_table_association" "subnet_association_c" {
  subnet_id      = aws_subnet.subnet_c.id
  route_table_id = aws_vpc.vpc.main_route_table_id
}

# --- ALB networking ---
resource "aws_security_group" "alb_security_group" {
  name   = "tay-tay-alb-security-group"
  vpc_id = aws_vpc.vpc.id
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

resource "aws_lb_target_group" "alb_target_group_client" {
  name        = "tay-tay-alb-target-group-client"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id
  health_check {
    matcher = "200,301,302"
    path    = "/"
    port                = "80"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "alb_target_group_server" {
  name        = "tay-tay-alb-target-group-server"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id
  health_check {
    matcher = "200,301,302"
    path    = "/api/v1/health"
    port                = "80"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    unhealthy_threshold = 2
  }
}

# --- ECS networking ---
resource "aws_security_group" "services_security_group" {
  name   = "tay-tay-client-service-security-group"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
provider "aws" {
  region = var.aws_region
}

# --- Terraform remote state in S3 bucket ---
terraform {
  backend "s3" {
    bucket         = "tay-tay-tfstate"
    key            = "tay-tay-ecs-client.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "tay-tay-tfstate-lock"
    encrypt        = true
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "tay-tay-tfstate"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "tay-tay-tfstate-lock"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# --- Modules ---

# --- networking ---
module "networking" {
  source = "./modules/networking"
  aws_region = var.aws_region
}

# --- ECR ---
module "ecr_client" {
  source = "./modules/ECR"
  name   = "tay-tay-ecr-repository-client"
  retention_count = 50
}
module "ecr_server" {
  source = "./modules/ECR"
  name   = "tay-tay-ecr-repository-server"
  retention_count = 50
}

# --- ALB ---
module "alb" {
  source = "./modules/ALB"
  name   = "tay-tay-alb"
  subnet_ids = module.networking.subnet_ids
  security_group_id = module.networking.alb_security_group_id
  path_target_map = {
    "/api/v1/*"   = module.networking.alb_target_group_arn_server,
    "/*" = module.networking.alb_target_group_arn_client,
  }
}

# --- RDS ---
module "rds" {
  source = "./modules/RDS"
  db_subnet_group_name   = module.networking.primary_db_subnet_group_name
  vpc_security_group_ids = [module.networking.primary_db_security_group_id]
}

# --- ECS ---
module "ecs_cluster" {
  source = "./modules/ECS/Cluster"
  name   = "tay-tay-ecs-cluster"
}

module "ecs_task_definition_client" {
  source = "./modules/ECS/TaskDefinition"
  container_name    = "tay-tay-client-container"
  container_port    = 5173
  cpu               = 256
  docker_repository = module.ecr_client.ecr_repository_url
  memory            = 512
  name              = "tay-tay-ecs-task-client"
  health_check_path = "/"
  database_secret_arn = module.rds.secret_arn
}
module "ecs_task_definition_server" {
  source = "./modules/ECS/TaskDefinition"
  container_name    = "tay-tay-server-container"
  container_port    = 8080
  cpu               = 256
  docker_repository = module.ecr_server.ecr_repository_url
  memory            = 512
  name              = "tay-tay-ecs-task-server"
  health_check_path = "/api/v1/health"
  database_secret_arn = module.rds.secret_arn
}

module "ecs_service_client" {
  source = "./modules/ECS/Service"
  security_group_id = module.networking.services_security_group_id
  arn_target_group = module.networking.alb_target_group_arn_client
  arn_task_definition = module.ecs_task_definition_client.arn_task_definition
  container_name = "tay-tay-client-container"
  container_port = 5173
  desired_tasks = 1
  ecs_cluster_id = module.ecs_cluster.ecs_cluster_id
  name = "tay-tay-ecs-service-client"
  subnets = module.networking.subnet_ids
}
module "ecs_service_server" {
  source = "./modules/ECS/Service"
  security_group_id = module.networking.services_security_group_id
  arn_target_group = module.networking.alb_target_group_arn_server
  arn_task_definition = module.ecs_task_definition_server.arn_task_definition
  container_name = "tay-tay-server-container"
  container_port = 8080
  desired_tasks = 1
  ecs_cluster_id = module.ecs_cluster.ecs_cluster_id
  name = "tay-tay-ecs-service-server"
  subnets = module.networking.subnet_ids
}
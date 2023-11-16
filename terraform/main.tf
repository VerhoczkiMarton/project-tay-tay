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

#256 (.25 vCPU) - Available memory values: 512 (0.5 GB), 1024 (1 GB), 2048 (2 GB)
#512 (.5 vCPU)  - Available memory values: 1024 (1 GB), 2048 (2 GB), 3072 (3 GB), 4096 (4 GB)
#1024 (1 vCPU)  - Available memory values: 2048 (2 GB), 3072 (3 GB), 4096 (4 GB), 5120 (5 GB), 6144 (6 GB), 7168 (7 GB), 8192 (8 GB)
#2048 (2 vCPU)  - Available memory values: Between 4096 (4 GB) and 16384 (16 GB) in increments of 1024 (1 GB)
#4096 (4 vCPU)  - Available memory values: Between 8192 (8 GB) and 30720 (30 GB) in increments of 1024 (1 GB)

module "ecs_task_definition_client" {
  source = "./modules/ECS/TaskDefinition"
  name              = "tay-tay-ecs-task-client"
  container_name    = "tay-tay-client-container"
  docker_repository = module.ecr_client.ecr_repository_url
  container_port    = 5173
  cpu               = 256
  memory            = 512
  health_check_path = "/"
  database_secret_arn = module.rds.secret_arn
}
module "ecs_task_definition_server" {
  source = "./modules/ECS/TaskDefinition"
  name              = "tay-tay-ecs-task-server"
  container_name    = "tay-tay-server-container"
  docker_repository = module.ecr_server.ecr_repository_url
  container_port    = 8080
  cpu               = 256
  memory            = 512
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
  ecs_cluster_id = module.ecs_cluster.ecs_cluster_id
  name = "tay-tay-ecs-service-server"
  subnets = module.networking.subnet_ids
}

module "ecs_autoscaling_client" {
  source = "./modules/ECS/Autoscaling"
  ecs_cluster_name = module.ecs_cluster.ecs_cluster_name
  ecs_service_name = module.ecs_service_client.ecs_service_name
  minimum_capacity = 1
  maximum_capacity = 3
  memory_utilization_high_threshold = 70
  cpu_utilization_high_threshold = 70
}

module "ecs_autoscaling_server" {
  source = "./modules/ECS/Autoscaling"
  ecs_cluster_name = module.ecs_cluster.ecs_cluster_name
  ecs_service_name = module.ecs_service_server.ecs_service_name
  minimum_capacity = 1
  maximum_capacity = 3
  memory_utilization_high_threshold = 90
  cpu_utilization_high_threshold = 80
}
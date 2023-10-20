variable "aws_region" {
  description = "AWS region"
}
variable "ecs_cluster" {
  description = "ECS cluster name"
}
variable "client_container_name" {
  description = "Client docker container name"
}
variable "client_ecr_repository" {
  description = "Client ECR repository name"
}
variable "client_ecs_service" {
  description = "Client ECS service name"
}
variable "client_ecs_task_definition_family" {
  description = "Client ECS task definition family"
}

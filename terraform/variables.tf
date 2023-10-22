variable "aws_region" {
  description = "AWS region"
}
variable "aws_ecs_cluster" {
  description = "ECS cluster name"
}
variable "aws_client_container_name" {
  description = "Client docker container name"
}
variable "aws_client_ecr_repository" {
  description = "Client ECR repository name"
}
variable "aws_client_ecs_service" {
  description = "Client ECS service name"
}
variable "aws_client_ecs_task_definition_family" {
  description = "Client ECS task definition family"
}
variable "aws_client_ecs_service_security_group" {
  description = "Client ECS service security group"
}
variable "aws_alb" {
  description = "Application Load Balancer name"
}
variable "aws_alb_security_group" {
  description = "Application Load Balancer security group"
}
variable "aws_client_alb_target_group" {
  description = "Client Application Load Balancer target group"
}
variable "aws_iam_ecs_task_execution_role" {
  description = "IAM ECS task execution role"
}
variable "aws_vpc_security_group" {
  description = "VPC security group"
}
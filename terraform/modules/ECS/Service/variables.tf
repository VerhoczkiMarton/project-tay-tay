variable "name" {
  description = "The name for the ecs service"
  type        = string
}

variable "desired_tasks" {
  description = "The minimum number of tasks to run in the service"
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group for the tasks"
  type        = string
}

variable "ecs_cluster_id" {
  description = "The ECS cluster ID in which the resources will be created"
  type        = string
}

variable "arn_target_group" {
  description = "The ARN of the AWS Target Group to put the ECS task"
  type        = string
}

variable "arn_task_definition" {
  description = "The ARN of the Task Definition to use to deploy the tasks"
  type        = string
}

variable "subnets" {
  description = "Subnets in which ecs will deploy the tasks"
  type        = list(any)
}

variable "container_port" {
  description = "The port that the container will listen request"
  type        = string
}

variable "container_name" {
  description = "The name of the container"
  type        = string
}
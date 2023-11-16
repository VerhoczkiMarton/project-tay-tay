variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "ecs_service_name" {
  description = "The name of the ECS service"
  type        = string
}

variable "minimum_capacity" {
  description = "The minimum number of tasks to run"
  type        = number
}

variable "maximum_capacity" {
  description = "The maximum number of tasks to run"
  type        = number
}

variable "cpu_utilization_high_threshold" {
  description = "The CPU utilization high threshold"
  type        = number
}

variable "memory_utilization_high_threshold" {
  description = "The memory utilization high threshold"
  type        = number
}
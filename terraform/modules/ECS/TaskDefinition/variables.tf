variable "name" {
  description = "The name for Task Definition"
  type        = string
}

variable "container_name" {
  description = "The name of the Container specified in the Task definition"
  type        = string
}

variable "cpu" {
  description = "The CPU value to assign to the container, read AWS documentation for available values"
  type        = string
}

variable "memory" {
  description = "The MEMORY value to assign to the container, read AWS documentation to available values"
  type        = string
}

variable "docker_repository" {
  description = "The docker registry URL in which ecs will get the Docker image"
  type        = string
}

variable "container_port" {
  description = "The port that the container will use to listen to requests"
  type        = number
}

variable "health_check_path" {
  description = "The path that the container will use to check if it is healthy"
  type        = string
}
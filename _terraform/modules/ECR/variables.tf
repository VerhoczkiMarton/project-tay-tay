variable "name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "retention_count" {
  description = "Number of images to keep in the repository"
  type        = number
}
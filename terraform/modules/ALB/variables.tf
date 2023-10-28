variable "name" {
  description = "A name for the ALB"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets IDs for ALB"
  type        = list(any)
  default     = []
}

variable "security_group_id" {
  description = "Security group ID for the ALB"
  type        = string
  default     = ""
}

variable "listener_target_group_arn" {
  description = "The ARNs of the created target groups"
  type        = string
  default     = ""
}
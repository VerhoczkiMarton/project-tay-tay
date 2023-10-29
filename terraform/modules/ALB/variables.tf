variable "name" {
  description = "A name for the ALB"
  type        = string
}

variable "path_target_map" {
  description = "A map of path patterns to target group ARNs"
  type        = map(string)
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
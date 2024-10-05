variable "allocated_storage_gb" {
    description = "The allocated storage in gigabytes"
    type        = number
    default     = 5
}

variable "instance_class" {
    description = "The instance type of the RDS instance"
    type        = string
    default     = "db.t3.micro"
}

variable "vpc_security_group_ids" {
    description = "A list of VPC security group IDs to associate with the DB instance"
    type        = list(string)
}

variable "db_subnet_group_name" {
    description = "The name of the DB subnet group to associate with this DB instance"
    type        = string
}
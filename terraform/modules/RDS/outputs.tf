output "primary_database_address" {
    value = aws_db_instance.primary_db.address
}

output "primary_database_port" {
    value = aws_db_instance.primary_db.port
}

output "primary_database_username" {
    value = aws_db_instance.primary_db.username
}
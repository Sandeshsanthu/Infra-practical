output "application_endpoint" {
  value       = "http://${aws_lb.external.dns_name}"
  description = "The public facing URL of your application infrastructure."
}

output "database_host" {
  value       = aws_db_instance.postgres.address
  description = "Secure private database endpoint for internal app configuration."
}

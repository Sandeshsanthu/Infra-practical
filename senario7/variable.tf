
# Output the connection endpoint
output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = data.aws_db_instance.existingdb.endpoint
}

# Output the DB Instance ID (useful for scripts)
output "rds_id" {
  description = "The ID of the RDS instance"
  value       = data.aws_db_instance.existingdb.id
}

# Output the VPC Security Groups attached to it
output "rds_security_groups" {
  description = "Security groups currently on the RDS"
  value       = data.aws_db_instance.existingdb.vpc_security_groups
}

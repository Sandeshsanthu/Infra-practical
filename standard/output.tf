output "vpc_tags_all" {
  value       = aws_vpc.production_vpc.tags_all
  description = "The actual combined map of default and resource tags applied by AWS."
}

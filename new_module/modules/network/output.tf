output "subnet_id" {
  value = aws_subnet.public.id # This ID will be passed to the EC2 module
}
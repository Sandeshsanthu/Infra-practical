resource "aws_vpc" "prod_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "prod-vpc" }
  
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "prod-public-subnet-1a" }
}
output "vpc_id" {
  value       = aws_vpc.prod_vpc.id
  description = "The ID of the production VPC"
}

output "subnet_id" {
  value       = aws_subnet.public_subnet.id
  description = "The ID of the public subnet"
}
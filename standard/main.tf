resource "aws_vpc" "production_vpc" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
    Name = "${var.environment}-vpc"
  }
  
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.production_vpc.id
  cidr_block        = "10.0.1.0/24"
  
  tags = {
    Name       = "${var.environment}-public-subnet-1a"
    Department = "FinOps-Shared" # Overrides 'Engineering' for this specific asset
  }
}
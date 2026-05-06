resource "aws_vpc" "test" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "sandbox-vpc" }
}

# 2. TWO SUBNETS (Required for RDS)
resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a" # Ensure this matches your provider region
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_db_subnet_group" "main" {
  name       = "main-subnet-group"
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
}


output "my_subnet_id" {
  value = aws_subnet.subnet_1.id
}

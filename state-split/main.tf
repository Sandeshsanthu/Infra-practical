# 1. THE VPC (The missing piece causing your error)
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

# 3. RDS SUBNET GROUP
resource "aws_db_subnet_group" "main" {
  name       = "main-subnet-group"
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
}

# 4. THE DATABASE
resource "aws_db_instance" "postgres" {
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  username             = "dbadmin"
  password             = "su03me12"
  db_subnet_group_name = aws_db_subnet_group.main.name
  skip_final_snapshot  = true
}

# 5. THE WEB SERVER
resource "aws_instance" "web_server" {
  ami           = "ami-0e2c8caa4b6378d8c" # Verified for us-east-1
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.subnet_1.id
}

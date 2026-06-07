# ==========================================
# PRIMARY REGION RESOURCES (us-east-1)
# ==========================================

resource "aws_vpc" "primary" {
  provider             = aws.primary
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "demo-primary-vpc" }
}

resource "aws_subnet" "primary_public" {
  provider                = aws.primary
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
  tags                    = { Name = "demo-primary-public-subnet" }
}

resource "aws_internet_gateway" "primary" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary.id
}

resource "aws_route_table" "primary" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary.id
  }
}

resource "aws_route_table_association" "primary" {
  provider       = aws.primary
  subnet_id      = aws_subnet.primary_public.id
  route_table_id = aws_route_table.primary.id
}

resource "aws_security_group" "primary_web" {
  provider = aws.primary
  name     = "primary-web-sg"
  vpc_id   = aws_vpc.primary.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "primary_server" {
  provider               = aws.primary
  ami                    = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS in us-east-1
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.primary_public.id
  vpc_security_group_ids = [aws_security_group.primary_web.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              echo "<h1>REGION OUTCOME: Running on PRIMARY (${var.primary_region})</h1>" > /var/www/html/index.html
              systemctl restart nginx
              EOF

  tags = { Name = "demo-primary-web-server" }
}

# ==========================================
# SECONDARY REGION RESOURCES (us-west-2)
# ==========================================

resource "aws_vpc" "secondary" {
  provider             = aws.secondary
  cidr_block           = "10.2.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "demo-secondary-vpc" }
}

resource "aws_subnet" "secondary_public" {
  provider                = aws.secondary
  vpc_id                  = aws_vpc.secondary.id
  cidr_block              = "10.2.1.0/24"
  map_public_ip_on_launch = true
  tags                    = { Name = "demo-secondary-public-subnet" }
}

resource "aws_internet_gateway" "secondary" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary.id
}

resource "aws_route_table" "secondary" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secondary.id
  }
}

resource "aws_route_table_association" "secondary" {
  provider       = aws.secondary
  subnet_id      = aws_subnet.secondary_public.id
  route_table_id = aws_route_table.secondary.id
}

resource "aws_security_group" "secondary_web" {
  provider = aws.secondary
  name     = "secondary-web-sg"
  vpc_id   = aws_vpc.secondary.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "secondary_server" {
  provider               = aws.secondary
  ami                    = "ami-0387d7b256531541b" # Ubuntu 22.04 LTS in us-west-2
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.secondary_public.id
  vpc_security_group_ids = [aws_security_group.secondary_web.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              echo "<h1>REGION OUTCOME: Running on PASSIVE SECONDARY (${var.secondary_region})</h1>" > /var/www/html/index.html
              systemctl restart nginx
              EOF

  tags = { Name = "demo-secondary-web-server" }
}

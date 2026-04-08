resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-north-1a"

}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-north-1b"
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.100.0/24"
  map_public_ip_on_launch = true

}
resource "aws_db_subnet_group" "rds_subgroup" {
  name       = "main-rds-group"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.main.id
  ingress  {
    from_port  = 22
    to_port    = 22
    protocol   = "tcp"
    cidr_blocks = ["24.239.143.14/32"]
  }
 egress {
     from_port = 0
     to_port = 0
     protocol = -1
     cidr_blocks = ["0.0.0.0/0"]
 }

}
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id
  ingress  {
    from_port      = 3306
    to_port        = 3306
    protocol       = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

}

resource "aws_instance" "bastion-sgs" {
  ami                    = "ami-0bfa6d0ea0fe2c5a1"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  depends_on = [ aws_security_group.bastion_sg, ]
}

resource "aws_db_instance" "secure_db" {
  allocated_storage      = 20
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  db_subnet_group_name   = aws_db_subnet_group.rds_subgroup.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false
  username = "sandeshs"
  password = "su03me12"
  skip_final_snapshot    = true 
}
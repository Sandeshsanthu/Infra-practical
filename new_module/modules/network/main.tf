resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    tags = {
      name = "${var.name_prefix}-vpc"
    }
  
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.subnet_cidr
    tags = { name= "${var.name_prefix}-public-subnet"}


  
}
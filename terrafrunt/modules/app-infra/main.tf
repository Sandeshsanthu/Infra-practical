provider "aws" {
    region = "us-east-2"
  
}

resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    tags = {Name = "${var.env}-vpc"}
  
}

resource "aws_subnet" "sub" {
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(var.vpc_cidr,8,1)
    tags = {Name = "${var.env}-subnet"}

}

resource "aws_instance" "web" {
    ami = "ami-078a9de9707bd5549"
    instance_type = var.instance_type
    subnet_id = aws_subnet.sub.id
    tags = { Name = "${var.env}-web-server" }

  
}
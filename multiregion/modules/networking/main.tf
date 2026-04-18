resource "aws_vpc" "this" {
     cidr_block = var.cidr_block
     enable_dns_hostnames = true

     tags = {
       Name = "vpc-${var.region_name}"
       Environment = var.env
     }
  
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.this.id
    cidr_block = cidrsubnet(var.cidr_block, 8, 1)
    tags = {
      Name = "pub-sub-${var.region_name}"
    }
  
}
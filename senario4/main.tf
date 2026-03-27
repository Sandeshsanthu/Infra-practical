resource "aws_eip" "myip"{
    domain = "vpc"
    count = var.create_eip ? 1 : 0
   
}
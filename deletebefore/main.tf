resource "aws_instance" "myvm" {
    ami = "ami-0bfa6d0ea0fe2c5a1"
    instance_type = "t3.micro"
    lifecycle {
      create_before_destroy = true
    }
    tags = {
        Name = var.myvm
    }
  
}
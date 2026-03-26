resource "aws_instance" "my-vm" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  tags = {
    Name = myvms
  }
}
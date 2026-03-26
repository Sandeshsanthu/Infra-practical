resource "aws_instance" "myvm"{
    ami = "ami-02dfbd4ff395f2a1b"
    instance_type = var.env_instance_type
    tags = {
        Name = "myserver-${var.env_instance_type}"
    }
}
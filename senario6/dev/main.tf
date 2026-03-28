module  "vpc"  {
    source = "terraform-aws-modules/vpc/aws"
    name = var.vpc_variables
    cidr = "10.0.0.0/16"
    
    azs = ["eu-north-1b"]
    private_subnets = ["10.0.101.0/24"]
    public_subnets =  ["10.0.1.0/24"]

    enable_nat_gateway = true
    single_nat_gateway = true

    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Envrionment = "Dev"
        Terraform = true
    }

}

resource "aws_security_group" "dev_security" {
    name = "allow-web-traffic-${var.vpc_variables}"
    description = "allow web traffic"
    depends_on = [ module.vpc.vpc_id ]
    vpc_id = module.vpc.vpc_id

    ingress  {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
        description= "allowed ports"

    }

    ingress  {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
        description= "allowed ports"

    }

    egress {
        from_port = 0
        to_port =  0 
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "allow web traffic sg"
    }

    
  
}


data "aws_ami" "ami-linux" {
    most_recent = true
    owners = ["amazon"]
    filter {
      name = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
  
}
resource "aws_instance" "myvm" {
    ami = data.aws_ami.ami-linux.id
    instance_type = "t3.micro"
    subnet_id = module.vpc.public_subnets[0]
    vpc_security_group_ids = [aws_security_group.dev_security.id]
    associate_public_ip_address = true
    tags = {
      name="my-vm"
    }

  
}
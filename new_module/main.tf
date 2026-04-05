module "ec2" {
    source = "./modules/ec2"
    ami_id = "ami-0bfa6d0ea0fe2c5a1"
    instance_type = "t2.micro"
    instance_name = "sandesh-vm"
    subnet_id = "subnetid"
  
}
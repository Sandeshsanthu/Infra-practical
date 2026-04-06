module "my_network" {
    source = "./modules/network"
    vpc_cidr = "10.0.0.0/16"
    subnet_cidr = "10.0.1.0/24"
    name_prefix = "dev"
  
}


module "ec2" {
    source = "./modules/ec2"
    ami_id = "ami-0bfa6d0ea0fe2c5a1"
    instance_type = "t3.micro"
    instance_name = "sandesh-vm"
    subnet_id = module.my_network.subnet_id
  
}
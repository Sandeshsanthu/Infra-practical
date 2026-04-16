module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    name = "ha-webapp-vpc"
    cidr = "10.0.0.0/16"
    azs = ["${var.region}a","${var.region}b"]
    public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets = ["10.0.10.0/24", "10.0.11.0/24"]
    enable_nat_gateway = true

  
}

resource "aws_security_group" "alb-sg" {
    vpc_id = module.vpc.vpc_id
    name = "asg-sg"
    ingress  {
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"] 

    }

    egress  {
        protocol = -1
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]


    }
  
}

resource "aws_alb" "web_alb" {
    load_balancer_type = "application"
    subnets = module.vpc.public_subnets
    security_groups = [aws_security_group.alb-sg.id]
  
}
resource "aws_alb_target_group" "web_tg" {
    port = 80
    protocol = "HTTP"
    vpc_id = module.vpc.vpc_id
    health_check {
      path = "/"
      interval = 30
    }
}

resource "aws_alb_listener" "http" {
    depends_on = [ aws_alb.web_alb, aws_alb_target_group.web_tg]
    load_balancer_arn = aws_alb.web_alb.arn
    port = 80
    default_action { 
    type = "forward"
    target_group_arn = aws_alb_target_group.web_tg.arn 
    }
  
}


resource "aws_launch_template" "web_lt" {
    name = "sandesh-asg"
    image_id = "ami-098e39bafa7e7303d"
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.alb-sg.id]
    user_data =  filebase64("${path.module}/user_data.sh")
  
}

resource "aws_autoscaling_group" "web_sg" {
    vpc_zone_identifier = module.vpc.private_subnets
    target_group_arns = [aws_alb_target_group.web_tg.arn]
    min_size = 2
    max_size = 4
    desired_capacity = 2
    launch_template { 
        id = aws_launch_template.web_lt.id
     version = "$Latest"
      }
}
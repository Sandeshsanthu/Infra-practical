resource "aws_security_group" "app_sg" {
  name        = "prod-app-sg"
  description = "App security group managed at high speed"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_node" {
  ami           = "ami-0c55b159cbfafe1f0" # standard Amazon Linux 2
  instance_type = "t3.micro"
  subnet_id     = data.terraform_remote_state.network.outputs.subnet_id
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  # Production Guardrails: Prevents performance tuning from dropping critical instances
  lifecycle {
    prevent_destroy       = true
    create_before_destroy = true
  }

  tags = { Name = "prod-application-node" }
}

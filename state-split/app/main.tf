data "terraform_remote_state" "network_layer" {
  backend = "local"
  config = {
    path = "../networking/terraform.tfstate"
  }
}

resource "aws_instance" "web_server" {
  ami           = "ami-0e2c8caa4b6378d8c"
  instance_type = "t3.micro"
  
  # FIX: Change this line to use the remote state
  subnet_id     = data.terraform_remote_state.network_layer.outputs.subnet_id
}



data "terraform_remote_state" "network_layer" {
  backend = "local"
  config = {
    path = "../networking/terraform.tfstate"
  }
}
resource "aws_db_instance" "postgres" {
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  username             = "dbadmin"
  password             = "su03me12"
  db_subnet_group_name = data.terraform_remote_state.network_layer.outputs.subnet_id
  skip_final_snapshot  = true
}

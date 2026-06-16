resource "aws_db_instance" "prod_postgres" {
  identifier           = "production-database"
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "15"
  instance_class       = "db.t4g.micro"
  username             = "db_admin"
  password             = "SuperSecretPassword123!" # Use secrets management in real production
  skip_final_snapshot  = true
}

include "root" {
  path = find_in_parent_folders()
}

# Point to the local module copy (or a Git repository URL in production)
terraform {
  source = "../../../modules//app-infra"
}

# Inject environment-specific inputs
inputs = {
  env           = "prod"
  vpc_cidr      = "10.1.0.0/16"
  instance_type = "t3.micro"
}

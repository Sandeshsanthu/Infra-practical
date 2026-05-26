# Automatically configure the remote state backend in AWS
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "state-bucket-sandesh-2026" # Change to a globally unique name
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    use_lockfile = true 
  }
}

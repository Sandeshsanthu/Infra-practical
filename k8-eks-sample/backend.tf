terraform {
  backend "s3" {
    bucket       = "t-form-state-bucket"
    key          = "prod/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true

  }
}
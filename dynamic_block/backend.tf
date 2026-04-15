terraform {
  backend "s3" {
    bucket = "state-bucket-sandesh-2026"
    region = "eu-north-1"
    key = "dynamic/terraform.tfstate"
    use_lockfile = true
    encrypt = true
    
  }
}
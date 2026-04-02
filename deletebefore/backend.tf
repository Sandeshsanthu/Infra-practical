terraform {
  backend "s3" {
    bucket = "state-bucket-sandesh-2026"
    key = "devs/terraform.tfstate"
    region = "eu-north-1"
    encrypt = true
    use_lockfile = true
    
  }
}
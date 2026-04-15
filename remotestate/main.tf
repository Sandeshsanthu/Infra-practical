data "terraform_remote_state" "network" {
    backend = "s3"
    config = {
      bucket = "state-bucket-sandesh-2026"
      region = "eu-north-1"
      key = "dev/terraform.tfstate"
    }
  
}

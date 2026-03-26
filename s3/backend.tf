terraform {  
  backend "s3" {  
    bucket       = "state-bucket-sandesh-2026"  
    key          = "terraform.tftate"  
    region       = "eu-north-1"  
    encrypt      = true  
    use_lockfile = true  #S3 native locking
  }  
}

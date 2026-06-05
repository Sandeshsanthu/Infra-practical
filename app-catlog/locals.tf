locals {
  common_tags = {
    Application = var.app_name
    Environment = var.environment
    ManagedBy   = "Terraform-Service-Catalog"
    ManagedTier = var.tier
  }

  tier_matrix = {
    light = {
      instance_type = "t3.micro"
      min_capacity  = 1
      max_capacity  = 2
      db_class      = "db.t4g.micro"
      backup_retention = 1
    }

 standard = {
      instance_type = "t3.medium"
      min_capacity  = 2
      max_capacity  = 4
      db_class      = "db.m6g.large"
      backup_retention = 7
    }
    enterprise = {
      instance_type = "c6g.xlarge"
      min_capacity  = 3
      max_capacity  = 10
      db_class      = "db.m6g.2xlarge"
      backup_retention = 30
    }
  }

  cfg = local.tier_matrix[var.tier]
}

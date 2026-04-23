locals {
  region_code = var.region
  org = "corp"


name_prefix = "${local.org}-${var.app_name}-${var.environment}-${var.region}"
name_prefix_flat = replace(local.name_prefix, "-", "")

 names = {
    resource_group  = lower("${local.name_prefix}-rg")
    storage_account = lower(substr("${local.name_prefix_flat}st", 0, 24))
    key_vault       = lower(substr("${local.name_prefix}-kv", 0, 24))
  }


   common_tags = {
    Env       = var.environment
    ManagedBy = "Terraform"
    App       = var.app_name
  }
}
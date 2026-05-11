locals {
  # In your sandbox, these are just names. 
  # In production, these would be Account IDs.
  target_accounts = {
    "dev_account"  = { role_name = "Standard-Admin-Role-Dev" }
    "prod_account" = { role_name = "Standard-Admin-Role-Prod" }
    "test_account" = { role_name = "Standard-Admin-Role-Test" }
  }
}

# The for_each loop happens here calling the module
module "deploy_roles" {
  source   = "./modules/standard_iam"
  for_each = local.target_accounts

  role_name = each.value.role_name
}

output "deployed_arns" {
  value = { for k, v in module.deploy_roles : k => v.role_arn }
}

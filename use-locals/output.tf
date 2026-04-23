output "demo_resource_group_name" {
    value = local.names.resource_group
  
}

output "demo_stroage_account" {
  
  value = local.names.storage_account
}

output "demo_tags" {
  value = local.common_tags
}
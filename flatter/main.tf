# Simulated VPC resource - built out dynamically
resource "aws_vpc" "network" {
  for_each = flatten([
    for env_key, env_val in var.environments : [
      for vpc_key, vpc_val in env_val.vpcs : {
        key  = "${env_key}_${vpc_key}"
        cidr = vpc_val.vpc_cidr
      }
    ]
  ]) == [] ? {} : { for v in flatten([for ek, ev in var.environments : [for vk, vv in ev.vpcs : { k = "${ek}_${vk}", c = vv.vpc_cidr }]]) : v.k => v }

  cidr_block           = each.value.c
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-${each.key}"
  }
}

# The target Subnet resource loop utilizing our flattened map
resource "aws_subnet" "flattened_subnets" {
  for_each = local.subnet_map

  # Reference the proper VPC dynamically via composite lookups
  vpc_id            = aws_vpc.network["${each.value.env_key}_${each.value.vpc_key}"].id
  cidr_block        = each.value.subnet_cidr
  
  tags = {
    Name        = "subnet-${each.value.env_key}-${each.value.vpc_key}-${each.value.subnet_key}"
    Environment = each.value.env_name
    Tier        = each.value.subnet_tier
    ManagedBy   = "Terraform"
  }
}

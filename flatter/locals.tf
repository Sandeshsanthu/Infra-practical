locals {
  # Step 1: Unroll the deeply nested maps and arrays into a flat list
  flat_subnet_list = flatten([
    for env_key, env_val in var.environments : [
      for vpc_key, vpc_val in env_val.vpcs : [
        for subnet in vpc_val.subnets : {
          # Unique tracking identifiers
          env_key    = env_key
          vpc_key    = vpc_key
          subnet_key = subnet.name
          
          # Inherited and individual network configurations
          env_name    = env_val.environment_name
          vpc_cidr    = vpc_val.vpc_cidr
          subnet_cidr = subnet.cidr
          subnet_tier = subnet.tier
        }
      ]
    ]
  ])

  # Step 2: Zip the list into a map using a distinct, composite string key
  # Format: "prod_primary_pub-1a"
  subnet_map = {
    for item in local.flat_subnet_list : 
    "${item.env_key}_${item.vpc_key}_${item.subnet_key}" => item
  }
}

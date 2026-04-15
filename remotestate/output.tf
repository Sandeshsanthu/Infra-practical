output "vpc" {
    value = data.terraform_remote_state.network.outputs.vpc_id
  
}

output "vm_id" {
    value = data.terraform_remote_state.network.outputs.vm_id.id
  
}
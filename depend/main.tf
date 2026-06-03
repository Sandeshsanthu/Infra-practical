data "external" "legacy_system" {
    program = [ "python", "${path.module}/test.py" ]
    query = {
    env = var.target_env
  }
  
}


resource "aws_ssm_parameter" "legacy_mapping" {
  name  = "/infrastructure/legacy-project-${data.external.legacy_system.result.legacy_project_id}"
  type  = "String"
  value = "CostCenter=${data.external.legacy_system.result.cost_center};Vlan=${data.external.legacy_system.result.network_vlan}"

  # Explicit dependency statement if logic requires strict creation order
  depends_on = [data.external.legacy_system]
}


output "integrated_api_data" {
  value = {
    vlan_id     = data.external.legacy_system.result.network_vlan
    project_num = data.external.legacy_system.result.legacy_project_id
    ssm_path    = aws_ssm_parameter.legacy_mapping.name
  }
}
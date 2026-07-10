/*
===============================================================================
 Archivo      : outputs.tf

 Descripción  :
 Publica información generada por Terraform para ser utilizada por otros
 módulos o por GitHub Actions durante el despliegue.

 Responsable : OPS
===============================================================================
/*
===============================================================================
 Outputs del proyecto
===============================================================================
*/

output "azure_resource_group_name" {
  value = module.azure.azure_resource_group_name
}

output "azure_resource_group_location" {
  value = module.azure.azure_resource_group_location
}

output "azure_log_analytics_workspace_name" {
  value = module.azure.azure_log_analytics_workspace_name
}

output "azure_log_analytics_workspace_id" {
  value = module.azure.azure_log_analytics_workspace_id
}
/*
===============================================================================
 Archivo      : main.tf

 Descripción
 Orquesta el despliegue de la infraestructura del MVP.
===============================================================================
*/

module "azure" {

  source = "./azure"

  azure_subscription_id              = var.azure_subscription_id
  azure_resource_group               = var.azure_resource_group
  azure_location                     = var.azure_location
  azure_log_analytics_workspace_name = var.azure_log_analytics_workspace_name

  sql_admin_username = var.sql_admin_username
  sql_admin_password = var.sql_admin_password

  prefix      = local.prefix
  environment = var.environment

  common_tags = local.common_tags

}

module "gcp" {

  source = "./gcp"

  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region

  prefix      = local.prefix
  environment = var.environment

  common_tags = local.common_tags

  cloud_run_service_name = var.cloud_run_service_name

  cloud_run_container_image = var.cloud_run_container_image

  cloud_run_container_port = var.cloud_run_container_port

}

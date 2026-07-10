/*
===============================================================================
 Archivo      : outputs.tf
 Proyecto     : FiberLink Multicloud MVP
 Curso        : Arquitectura de Soluciones Multicloud
 Grupo        : Grupo V

 Descripción

 Publica la información de los recursos Azure para facilitar su utilización
 por otros módulos Terraform y por GitHub Actions.

===============================================================================
*/

output "azure_resource_group_name" {
  description = "Nombre del Resource Group."
  value       = data.azurerm_resource_group.main.name
}

output "azure_resource_group_location" {
  description = "Región del Resource Group."
  value       = data.azurerm_resource_group.main.location
}

output "azure_log_analytics_workspace_name" {
  description = "Nombre del Log Analytics Workspace."
  value       = data.azurerm_log_analytics_workspace.main.name
}

output "azure_log_analytics_workspace_id" {
  description = "Id del Log Analytics Workspace."
  value       = data.azurerm_log_analytics_workspace.main.id
}

output "container_apps_environment_name" {

  description = "Nombre del Azure Container Apps Environment."

  value = azurerm_container_app_environment.main.name

}

output "container_apps_environment_id" {

  description = "Id del Azure Container Apps Environment."

  value = azurerm_container_app_environment.main.id

}

output "service_bus_namespace_name" {

  description = "Nombre del Azure Service Bus Namespace."

  value = azurerm_servicebus_namespace.main.name

}

output "service_bus_namespace_id" {

  description = "Id del Azure Service Bus Namespace."

  value = azurerm_servicebus_namespace.main.id

}

output "key_vault_name" {

  description = "Nombre del Azure Key Vault."

  value = azurerm_key_vault.main.name

}

output "key_vault_id" {

  description = "Id del Azure Key Vault."

  value = azurerm_key_vault.main.id

}

output "api_management_name" {

  description = "Nombre del API Management."

  value = azurerm_api_management.main.name

}

output "api_management_gateway_url" {

  description = "Gateway URL del API Management."

  value = azurerm_api_management.main.gateway_url

}

output "sql_server_name" {

  description = "Nombre del Azure SQL Server."

  value = azurerm_mssql_server.main.name

}

output "sql_database_name" {

  description = "Nombre de la base de datos."

  value = azurerm_mssql_database.main.name

}

###############################################################################
# Managed Identity
###############################################################################

output "managed_identity_id" {

  value = azurerm_user_assigned_identity.mvp.id

}

output "managed_identity_principal_id" {

  value = azurerm_user_assigned_identity.mvp.principal_id

}
/*
===============================================================================
 Archivo      : variables.tf
 Módulo       : Azure

 Descripción
 Variables de entrada del módulo Azure.
===============================================================================
*/

variable "azure_subscription_id" {
  description = "Id de la suscripción Azure."
  type        = string
}

variable "azure_resource_group" {
  description = "Resource Group existente."
  type        = string
}

variable "azure_location" {
  description = "Región de Azure."
  type        = string
}

variable "environment" {
  description = "Ambiente del despliegue."
  type        = string
}

variable "prefix" {
  description = "Prefijo de nombres del proyecto."
  type        = string
}

variable "azure_log_analytics_workspace_name" {
  description = "Log Analytics Workspace existente."
  type        = string
}

variable "common_tags" {
  description = "Etiquetas comunes."
  type        = map(string)
}

variable "sql_admin_username" {
  description = "Usuario administrador del servidor SQL."
  type        = string
}

variable "sql_admin_password" {
  description = "Contraseña del administrador SQL."
  type        = string
  sensitive   = true
}
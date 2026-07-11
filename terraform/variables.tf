/*
===============================================================================
 Archivo      : variables.tf

 Descripción  :
 Variables globales utilizadas por toda la infraestructura del MVP.

 Responsable : OPS
===============================================================================
*/

###############################
# Proyecto
###############################

variable "project_name" {
  description = "Nombre del proyecto."
  type        = string
}

variable "environment" {
  description = "Ambiente de despliegue."
  type        = string
}

###############################
# Azure
###############################

variable "azure_subscription_id" {
  description = "Id de la suscripción Azure."
  type        = string
}

variable "azure_resource_group" {
  description = "Resource Group existente."
  type        = string
}

variable "azure_location" {
  description = "Región Azure."
  type        = string
}

variable "azure_log_analytics_workspace_name" {
  description = "Nombre del Log Analytics Workspace existente."
  type        = string
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

###############################
# Google Cloud
###############################

variable "gcp_project_id" {
  description = "Proyecto Google Cloud."
  type        = string
}

variable "gcp_region" {
  description = "Región Google Cloud."
  type        = string
}

###############################################################################
# Cloud Run
###############################################################################

variable "cloud_run_service_name" {

  description = "Nombre del servicio Cloud Run."

  type = string

  default = "flk-dev-ms-eventos-negocio"

}

variable "cloud_run_container_image" {

  description = "Imagen Docker del microservicio."

  type = string

  default = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "cloud_run_container_port" {

  description = "Puerto del contenedor."

  type = number

  default = 8080

}
/*
===============================================================================
 Archivo      : variables.tf
 Módulo       : Google Cloud

 Descripción
 Variables de entrada del módulo GCP.
===============================================================================
*/

variable "gcp_project_id" {
  description = "Id del proyecto Google Cloud."
  type        = string
}

variable "gcp_region" {
  description = "Región de despliegue."
  type        = string
}

variable "prefix" {
  description = "Prefijo de nombres."
  type        = string
}

variable "environment" {
  description = "Ambiente."
  type        = string
}

variable "common_tags" {
  description = "Etiquetas comunes."
  type        = map(string)
}

###############################################################################
# Cloud Run
###############################################################################

variable "cloud_run_service_name" {

  description = "Nombre del servicio Cloud Run."

  type = string

}

variable "cloud_run_container_image" {

  description = "Imagen Docker del microservicio."

  type = string

}

variable "cloud_run_container_port" {

  description = "Puerto expuesto por el contenedor."

  type    = number
  default = 8080

}
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

  type = string

  default = "fiberlink"

}

variable "environment" {

  description = "Ambiente de despliegue."

  type = string

  default = "dev"

}

###############################
# Azure
###############################

variable "azure_subscription_id" {

  description = "Id de la suscripción Azure."

  type = string

  default = "088b9168-fdd5-4280-83de-02aaee8b9daf"

}

variable "azure_resource_group" {

  description = "Resource Group existente."

  type = string

  default = "rg_Maria_Baute"

}

variable "azure_location" {

  description = "Región Azure."

  type = string

  default = "East US"

}

###############################
# Google Cloud
###############################

variable "gcp_project_id" {

  description = "Proyecto Google Cloud."

  type = string

  default = "utec-posgrado-01"

}

variable "gcp_region" {

  description = "Región Google Cloud."

  type = string

  default = "us-central1"

}
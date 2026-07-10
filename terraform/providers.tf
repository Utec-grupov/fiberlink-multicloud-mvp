/*
===============================================================================
 Archivo      : providers.tf

 Descripción  :
 Configura los proveedores cloud utilizados por el MVP.

 Azure
 -----
 Resource Group : rg_Maria_Baute
 Región         : East US

 Google Cloud
 ------------
 Proyecto       : utec-posgrado-01

 Se utilizará la región us-central1 debido a:

 • Alta disponibilidad de servicios de Google Cloud.
 • Excelente soporte para Cloud Run, Pub/Sub y BigQuery.
 • Costos competitivos para ambientes de desarrollo.
 • Baja latencia para servicios globales.
 • Región ampliamente utilizada en laboratorios y proyectos académicos.

 Responsable : OPS
===============================================================================
*/

provider "azurerm" {

  features {}

  subscription_id = var.azure_subscription_id

}

provider "google" {

  project = var.gcp_project_id
  region  = var.gcp_region

}
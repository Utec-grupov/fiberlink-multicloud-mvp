/*
===============================================================================
 Archivo      : versions.tf

 Descripción  :
 Define la versión mínima de Terraform y los proveedores utilizados por el
 proyecto FiberLink Multicloud MVP.

 Responsable  : OPS
 Proyecto      : FiberLink Multicloud MVP
===============================================================================
*/

terraform {

  required_version = ">= 1.8.0"

  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }

  }

}
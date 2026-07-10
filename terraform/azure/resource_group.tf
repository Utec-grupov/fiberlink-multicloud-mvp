/*
===============================================================================
 Archivo      : resource_group.tf
 Proyecto     : FiberLink Multicloud MVP
 Curso        : Arquitectura de Soluciones Multicloud
 Grupo        : Grupo V

 Descripción

 Referencia el Resource Group existente asignado al proyecto.

 El Resource Group NO será administrado por Terraform debido a que fue
 provisionado previamente para el laboratorio del curso.

 Todos los recursos Azure del MVP utilizarán este Resource Group.

===============================================================================
*/

###############################################################################
# Resource Group existente
###############################################################################

data "azurerm_resource_group" "main" {

  name = var.azure_resource_group

}
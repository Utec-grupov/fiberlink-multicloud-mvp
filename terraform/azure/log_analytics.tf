/*
===============================================================================
 Archivo      : log_analytics.tf
 Proyecto     : FiberLink Multicloud MVP
 Curso        : Arquitectura de Soluciones Multicloud
 Grupo        : Grupo V

 Descripción

 Referencia el Azure Log Analytics Workspace existente utilizado por el
 laboratorio.

 Este recurso NO será administrado por Terraform debido a que fue creado
 previamente.

 Será utilizado por Azure Container Apps para almacenar:

 • Logs
 • Métricas
 • Diagnósticos

 Forma parte de la plataforma de observabilidad del MVP.

 Decisión de Arquitectura

 AZ-001 - Reutilizar la infraestructura base del laboratorio mediante
           Data Sources en lugar de crear nuevos recursos.

===============================================================================
*/

###############################################################################
# Log Analytics Workspace existente
###############################################################################

data "azurerm_log_analytics_workspace" "main" {

  name                = var.azure_log_analytics_workspace_name
  resource_group_name = data.azurerm_resource_group.main.name

}
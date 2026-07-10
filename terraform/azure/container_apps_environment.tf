/*
===============================================================================
 Archivo      : container_apps_environment.tf
 Proyecto     : FiberLink Multicloud MVP
 Curso        : Arquitectura de Soluciones Multicloud
 Grupo        : Grupo V

 Descripción

 Crea el Azure Container Apps Environment donde se desplegarán los
 microservicios del MVP.

 El entorno reutiliza el Log Analytics Workspace existente del laboratorio
 para almacenar:

 - Logs
 - Métricas
 - Diagnósticos

 Decisiones 
 Se utilizará un único Azure Container Apps Environment para el MVP.
 El Environment reutiliza el Log Analytics Workspace existente mediante
 un Data Source.

===============================================================================
*/

###############################################################################
# Azure Container Apps Environment
###############################################################################

resource "azurerm_container_app_environment" "main" {

  name = "${var.prefix}-${var.environment}-acae"

  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.main.id

  tags = var.common_tags

}
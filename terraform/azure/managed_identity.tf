/*
===============================================================================
 Archivo      : managed_identity.tf

 Proyecto     : FiberLink Multicloud MVP
 Curso        : Arquitectura de Soluciones Multicloud
 Grupo        : Grupo V

 Descripción

 Identidad administrada utilizada por los Azure Container Apps del MVP.

===============================================================================
*/

###############################################################################
# User Assigned Managed Identity
###############################################################################

resource "azurerm_user_assigned_identity" "mvp" {

  name = "${var.prefix}-${var.environment}-identity"

  location = data.azurerm_resource_group.main.location

  resource_group_name = data.azurerm_resource_group.main.name

  tags = var.common_tags

}
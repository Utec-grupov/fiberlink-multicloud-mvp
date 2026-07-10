/*
===============================================================================
 Archivo      : client_config.tf
 Proyecto     : FiberLink Multicloud MVP
 Curso        : Arquitectura de Soluciones Multicloud
 Grupo        : Grupo V

 Descripción

 Obtiene información de la identidad autenticada en Azure.

 No crea recursos. Únicamente consulta la identidad utilizada por Terraform
 para recuperar información como Tenant ID, Object ID y Client ID.

===============================================================================
*/

data "azurerm_client_config" "current" {}
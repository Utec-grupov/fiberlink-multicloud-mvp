/*
===============================================================================
 Archivo      : service_bus.tf
 Proyecto     : FiberLink Multicloud MVP
 Curso        : Arquitectura de Soluciones Multicloud
 Grupo        : Grupo V

 Descripción

 Crea el Azure Service Bus Namespace utilizado para implementar la mensajería
 del MVP basada en eventos.

 Este servicio soporta el patrón Publisher–Subscriber definido en la
 arquitectura de solución.

===============================================================================
*/

###############################################################################
# Azure Service Bus Namespace
###############################################################################

resource "azurerm_servicebus_namespace" "main" {

  name = "${var.prefix}-${var.environment}-bus"

  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  sku = "Standard"

  tags = var.common_tags

}
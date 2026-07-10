/*
===============================================================================
 Archivo      : api_management.tf
 Proyecto     : FiberLink Multicloud MVP
 Curso        : Arquitectura de Soluciones Multicloud
 Grupo        : Grupo V

 Descripción

 Crea la instancia de Azure API Management que actuará como puerta de entrada
 para las APIs del MVP.

 Decisiones

 Se utiliza la SKU Developer por ser adecuada para ambientes académicos.
 No se utiliza integración con VNet debido a que la solución está basada
 completamente en servicios PaaS.

===============================================================================
*/

###############################################################################
# Azure API Management
###############################################################################

resource "azurerm_api_management" "main" {

  name = "${var.prefix}-${var.environment}-apim"

  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  publisher_name  = "Grupo V"
  publisher_email = "grupo-v@utec.edu.pe"

  sku_name = "Developer_1"

  tags = var.common_tags

}
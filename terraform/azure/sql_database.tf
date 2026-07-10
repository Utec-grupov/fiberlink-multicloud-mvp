/*
===============================================================================
 Archivo      : sql_database.tf
 Proyecto     : FiberLink Multicloud MVP
 Curso        : Arquitectura de Soluciones Multicloud
 Grupo        : Grupo V

 Descripción

 Crea el servidor Azure SQL y la base de datos principal utilizada por
 el MVP.

===============================================================================
*/

###############################################################################
# Azure SQL Server
###############################################################################

resource "azurerm_mssql_server" "main" {

  name                = "${var.prefix}-${var.environment}-sqlsrv"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  version = "12.0"

  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password

  tags = var.common_tags

}

###############################################################################
# Azure SQL Database
###############################################################################

resource "azurerm_mssql_database" "main" {

  name = "${var.prefix}-${var.environment}-db"

  server_id = azurerm_mssql_server.main.id

  sku_name = "Basic"

  tags = var.common_tags

}

###############################################################################
# Firewall
###############################################################################

resource "azurerm_mssql_firewall_rule" "azure_services" {

  name = "AllowAzureServices"

  server_id = azurerm_mssql_server.main.id

  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"

}
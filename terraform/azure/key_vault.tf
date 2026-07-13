/*
===============================================================================
 Archivo      : key_vault.tf
 Proyecto     : FiberLink Multicloud MVP
 Curso        : Arquitectura de Soluciones Multicloud
 Grupo        : Grupo V

 Descripción

 Crea el Azure Key Vault utilizado para almacenar los secretos del MVP.

 Inicialmente únicamente se crea el servicio. Los secretos serán incorporados
 posteriormente cuando la infraestructura completa esté desplegada.

===============================================================================
*/

###############################################################################
# Azure Key Vault
###############################################################################

resource "azurerm_key_vault" "main" {

  name = "${var.prefix}${var.environment}kv"

  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  tenant_id = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  purge_protection_enabled = false

  soft_delete_retention_days = 7

  tags = var.common_tags

}

###############################################################################
# Key Vault Access Policy
###############################################################################

resource "azurerm_key_vault_access_policy" "managed_identity" {

  key_vault_id = azurerm_key_vault.main.id

  tenant_id = data.azurerm_client_config.current.tenant_id

  object_id = azurerm_user_assigned_identity.mvp.principal_id

  secret_permissions = [
    "Get",
    "List"
  ]

}
###############################################################################
# Key Vault Access Policy - Administrator
###############################################################################

resource "azurerm_key_vault_access_policy" "administrator" {

  key_vault_id = azurerm_key_vault.main.id

  tenant_id = data.azurerm_client_config.current.tenant_id

  object_id = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete"
  ]

  key_permissions = [
    "Get",
    "List",
    "Create",
    "Delete",
    "Update"
  ]

}
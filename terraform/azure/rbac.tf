/*
===============================================================================
 Archivo      : rbac.tf

 Proyecto     : FiberLink Multicloud MVP
 Curso        : Arquitectura de Soluciones Multicloud
 Grupo        : Grupo V

 Descripción

 Asigna los permisos mínimos requeridos para que los Azure Container Apps
 interactúen con los servicios del MVP.

===============================================================================
*/

###############################################################################
# Service Bus Data Sender
###############################################################################

resource "azurerm_role_assignment" "servicebus_sender" {

  scope = azurerm_servicebus_namespace.main.id

  role_definition_name = "Azure Service Bus Data Sender"

  principal_id = azurerm_user_assigned_identity.mvp.principal_id

}

###############################################################################
# Service Bus Data Receiver
###############################################################################

resource "azurerm_role_assignment" "servicebus_receiver" {

  scope = azurerm_servicebus_namespace.main.id

  role_definition_name = "Azure Service Bus Data Receiver"

  principal_id = azurerm_user_assigned_identity.mvp.principal_id

}

###############################################################################
# Key Vault Secrets User
###############################################################################

resource "azurerm_role_assignment" "keyvault_secrets_user" {

  scope = azurerm_key_vault.main.id

  role_definition_name = "Key Vault Secrets User"

  principal_id = azurerm_user_assigned_identity.mvp.principal_id

}
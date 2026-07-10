/*
===============================================================================
 Archivo      : service_accounts.tf

 Proyecto     : FiberLink Multicloud MVP
 Curso        : Arquitectura de Soluciones Multicloud
 Grupo        : Grupo V

 Descripción

 Define las Service Accounts utilizadas por los microservicios desplegados
 en Google Cloud Run.

===============================================================================
*/

###############################################################################
# Service Account - Cloud Run
###############################################################################

resource "google_service_account" "mvp" {

  account_id = "${var.prefix}-${var.environment}-mvp"

  display_name = "FiberLink MVP Service Account"

  description = "Cuenta de servicio utilizada por los microservicios del MVP."

}
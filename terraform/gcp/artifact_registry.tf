/*
===============================================================================
 Archivo      : artifact_registry.tf

 Proyecto     : FiberLink Multicloud MVP
 Curso        : Arquitectura de Soluciones Multicloud
 Grupo        : Grupo V

 Descripción

 Repositorio de imágenes Docker utilizado por los microservicios
 desplegados en Google Cloud Run.

===============================================================================
*/

###############################################################################
# Artifact Registry
###############################################################################

resource "google_artifact_registry_repository" "containers" {

  location = var.gcp_region

  repository_id = "${var.prefix}-${var.environment}-containers"

  description = "Repositorio Docker del MVP FiberLink."

  format = "DOCKER"

}
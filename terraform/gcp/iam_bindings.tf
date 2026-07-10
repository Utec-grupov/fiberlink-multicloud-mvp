/*
===============================================================================
 Archivo      : iam_bindings.tf

 Proyecto     : FiberLink Multicloud MVP
 Curso        : Arquitectura de Soluciones Multicloud
 Grupo        : Grupo V

 Descripción

 Asigna los permisos mínimos requeridos para que los microservicios
 desplegados en Cloud Run interactúen con los servicios del MVP.

===============================================================================
*/

###############################################################################
# Pub/Sub Publisher
###############################################################################

resource "google_project_iam_member" "pubsub_publisher" {

  project = var.gcp_project_id

  role = "roles/pubsub.publisher"

  member = "serviceAccount:${google_service_account.mvp.email}"

}

###############################################################################
# Pub/Sub Subscriber
###############################################################################

resource "google_project_iam_member" "pubsub_subscriber" {

  project = var.gcp_project_id

  role = "roles/pubsub.subscriber"

  member = "serviceAccount:${google_service_account.mvp.email}"

}

###############################################################################
# BigQuery Data Editor
###############################################################################

resource "google_project_iam_member" "bigquery_editor" {

  project = var.gcp_project_id

  role = "roles/bigquery.dataEditor"

  member = "serviceAccount:${google_service_account.mvp.email}"

}

###############################################################################
# Logging Writer
###############################################################################

resource "google_project_iam_member" "logging_writer" {

  project = var.gcp_project_id

  role = "roles/logging.logWriter"

  member = "serviceAccount:${google_service_account.mvp.email}"

}
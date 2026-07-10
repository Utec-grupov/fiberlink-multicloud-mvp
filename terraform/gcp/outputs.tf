/*
===============================================================================
 Archivo      : outputs.tf

 Descripción

 Publica la información de los recursos GCP.

===============================================================================
*/

output "pubsub_topic_name" {

  description = "Nombre del Pub/Sub Topic."

  value = google_pubsub_topic.integration.name

}

output "pubsub_subscription_name" {

  description = "Nombre de la suscripción."

  value = google_pubsub_subscription.integration.name

}

output "bigquery_dataset_id" {

  description = "Dataset principal de BigQuery."

  value = google_bigquery_dataset.analytics.dataset_id

}

output "bigquery_table_name" {

  description = "Tabla principal de eventos."

  value = google_bigquery_table.integration_events.table_id

}

output "artifact_registry_repository" {

  description = "Repositorio Docker."

  value = google_artifact_registry_repository.containers.repository_id

}

###############################################################################
# Cloud Run
###############################################################################

output "cloud_run_service_name" {

  description = "Nombre del servicio Cloud Run."

  value = google_cloud_run_v2_service.main.name

}

output "cloud_run_service_uri" {

  description = "URI del servicio Cloud Run."

  value = google_cloud_run_v2_service.main.uri

}

###############################################################################
# Service Account
###############################################################################

output "service_account_email" {

  description = "Service Account utilizada por Cloud Run."

  value = google_service_account.mvp.email

}

output "service_account_name" {

  description = "Nombre de la Service Account."

  value = google_service_account.mvp.name

}
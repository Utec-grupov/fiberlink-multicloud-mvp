/*
===============================================================================
 Archivo      : bigquery.tf

 Proyecto     : FiberLink Multicloud MVP
 Curso        : Arquitectura de Soluciones Multicloud
 Grupo        : Grupo V

 Descripción

 Implementa el almacenamiento analítico del MVP mediante BigQuery.

 Recursos

 • BigQuery Dataset
 • Tabla de eventos de integración

===============================================================================
*/

###############################################################################
# BigQuery Dataset
###############################################################################

resource "google_bigquery_dataset" "analytics" {

  dataset_id = "fiberlink_analytics"

  friendly_name = "FiberLink Analytics"

  description = "Repositorio analítico principal del MVP."

  location = var.gcp_region

}

###############################################################################
# Tabla de eventos de integración
###############################################################################

resource "google_bigquery_table" "integration_events" {

  dataset_id = google_bigquery_dataset.analytics.dataset_id

  table_id = "integration_events"

  deletion_protection = false

  schema = jsonencode([

    {
      name = "event_id"
      type = "STRING"
      mode = "REQUIRED"
    },

    {
      name = "correlation_id"
      type = "STRING"
      mode = "REQUIRED"
    },

    {
      name = "event_source"
      type = "STRING"
      mode = "REQUIRED"
    },

    {
      name = "event_type"
      type = "STRING"
      mode = "REQUIRED"
    },

    {
      name = "payload"
      type = "STRING"
      mode = "NULLABLE"
    },

    {
      name = "event_timestamp"
      type = "TIMESTAMP"
      mode = "REQUIRED"
    }

  ])

}
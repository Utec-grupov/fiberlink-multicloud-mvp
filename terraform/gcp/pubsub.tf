/*
===============================================================================
 Archivo      : pubsub.tf

 Proyecto     : FiberLink Multicloud MVP

 Descripción

 Implementa la infraestructura de mensajería de Google Cloud
 utilizada para la integración entre Azure y GCP.

 Recursos

 - Pub/Sub Topic
 - Pub/Sub Subscription

===============================================================================
*/

###############################################################################
# Pub/Sub Topic
###############################################################################

resource "google_pubsub_topic" "integration" {

  name = "${var.prefix}-${var.environment}-integration-topic"

}

###############################################################################
# Pub/Sub Subscription
###############################################################################

resource "google_pubsub_subscription" "integration" {

  name = "${var.prefix}-${var.environment}-integration-sub"

  topic = google_pubsub_topic.integration.name

  ack_deadline_seconds = 20

  message_retention_duration = "604800s"

}
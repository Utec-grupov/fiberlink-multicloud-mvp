/*
===============================================================================
 Archivo      : cloud_run.tf

 Proyecto     : FiberLink Multicloud MVP
 Curso        : Arquitectura de Soluciones Multicloud
 Grupo        : Grupo V

 Descripción

 Implementa el servicio Cloud Run que alojará los microservicios del MVP.

 La infraestructura es responsabilidad de Terraform.
 La imagen Docker es suministrada por el equipo de desarrollo mediante
 variables de entrada.

===============================================================================
*/

###############################################################################
# Cloud Run Service
###############################################################################

resource "google_cloud_run_v2_service" "main" {

  name = var.cloud_run_service_name

  location = var.gcp_region

  deletion_protection = false

  ingress = "INGRESS_TRAFFIC_ALL"

  template {

    service_account = google_service_account.mvp.email

    containers {

      image = var.cloud_run_container_image

      ports {

        container_port = var.cloud_run_container_port

      }

    }

  }

}
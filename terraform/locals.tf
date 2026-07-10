/*
===============================================================================
 Archivo      : locals.tf

 Descripción  :
 Centraliza la convención de nombres y las etiquetas utilizadas por todos los
 recursos del MVP.

 Convención

 flk-<ambiente>-<recurso>

 Ejemplo

 flk-dev-apim
 flk-dev-sb
 flk-dev-sql
 flk-dev-cr

 Responsable : OPS
===============================================================================
*/

locals {

  prefix = "flk"

  common_tags = {

    Proyecto        = "FiberLink-MVP"
    Grupo           = "Grupo-V"
    Curso           = "Arquitectura de Soluciones Multicloud"
    Ambiente        = var.environment
    AdministradoPor = "Terraform"
    Responsable     = "OPS"

  }

}
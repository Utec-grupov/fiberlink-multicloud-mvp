/*
===============================================================================
 Archivo      : outputs.tf

 Descripción  :
 Publica información generada por Terraform para ser utilizada por otros
 módulos o por GitHub Actions durante el despliegue.

 Responsable : OPS
===============================================================================
*/

output "project_name" {

  value = var.project_name

}

output "environment" {

  value = var.environment

}

/*
===============================================================================
 Archivo      : backend.tf

 Descripción

 Define el backend utilizado por Terraform para almacenar el archivo de estado
 (terraform.tfstate).

 Durante la construcción inicial del MVP se utilizará un backend local para
 simplificar el desarrollo y las pruebas.

 Posteriormente podrá migrarse a Azure Storage para permitir despliegues
 colaborativos mediante GitHub Actions sin modificar el resto del proyecto.

 Responsable : OPS
===============================================================================
*/

terraform {

  backend "local" {

    path = "terraform.tfstate"

  }

}
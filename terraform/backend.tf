/*
===============================================================================
 Archivo      : backend.tf

 Descripción

 Configura el backend utilizado por Terraform para almacenar el archivo de
 estado (terraform.tfstate).

------------------------------------------------------------------------------
Etapa de desarrollo
------------------------------------------------------------------------------

Durante la construcción del MVP se utilizará un backend local para facilitar el
desarrollo y permitir que cualquier integrante del equipo pueda ejecutar el
proyecto utilizando su propia cuenta de Azure o Google Cloud.

El backend local evita dependencias entre integrantes durante el desarrollo de
la infraestructura.

------------------------------------------------------------------------------
Migración a Backend Remoto
------------------------------------------------------------------------------

Antes de integrar el despliegue automatizado mediante GitHub Actions deberá
ejecutarse el proyecto Terraform ubicado en:

    terraform/bootstrap-backend

Este proyecto creará:

• Azure Storage Account
• Blob Container

Una vez creada dicha infraestructura:

1. Copiar terraform.tfvars.example como terraform.tfvars.

2. Completar los valores correspondientes al ambiente donde se realizará el
   despliegue.

3. Sustituir el backend local por un backend remoto AzureRM.

4. Ejecutar:

       terraform init -migrate-state

para migrar automáticamente el archivo terraform.tfstate hacia Azure Storage.

===============================================================================
*/

terraform {

  backend "local" {

    path = "terraform.tfstate"

  }

}
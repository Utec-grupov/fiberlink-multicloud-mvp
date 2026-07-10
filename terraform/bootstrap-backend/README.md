# Bootstrap Backend

## Objetivo

Crear la infraestructura mínima necesaria para almacenar el estado de Terraform
(terraform.tfstate) en Azure Storage.

Este proyecto deberá ejecutarse una única vez antes de integrar el despliegue
automatizado mediante GitHub Actions.

---

## Recursos creados

- Azure Storage Account
- Blob Container

---

## Procedimiento

1. Copiar:

terraform.tfvars.example

como:

terraform.tfvars

2. Completar los valores correspondientes al ambiente donde se realizará el
despliegue.

3. Ejecutar:

terraform init

terraform plan

terraform apply

4. Actualizar el archivo backend.tf del proyecto principal.

5. Ejecutar:

terraform init -migrate-state

para migrar el estado local hacia Azure Storage.

---

## Observación

Este proyecto únicamente prepara el backend remoto de Terraform.

No despliega recursos funcionales del MVP.
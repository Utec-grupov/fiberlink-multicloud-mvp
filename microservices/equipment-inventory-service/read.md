git clone https://github.com/mleyvag/MOD3-LAB2.git
cd MOD3-LAB2.git/app/
npm install
node index.js
<IP_Publica>:8080/health



az login --use-device-code
az extension add --name containerapp --upgrade

export LOCATION="eastus"
#Nombre de tu Resource Group en Azure asignado
export RESOURCE_GROUP="rg_Wilmer_Ramos"
export IDENTITY_NAME="api-equipment-inventory-identity"
export ENVIRONMENT="api-equipment-inventory-environment"
export REGISTRY_NAME="flkdevacrepo"
export CONTAINER_APP_NAME="apiequipment"


az identity create \
--name $IDENTITY_NAME \
--resource-group $RESOURCE_GROUP


IDENTITY_ID=$(az identity show \
--name $IDENTITY_NAME \
--resource-group $RESOURCE_GROUP \
--query id \
--output tsv)

echo $IDENTITY_ID


az containerapp env create \
--name $ENVIRONMENT \
--resource-group $RESOURCE_GROUP \
--location $LOCATION \
--mi-user-assigned $IDENTITY_ID

az acr create \
--resource-group $RESOURCE_GROUP \
--name $REGISTRY_NAME \
--sku Basic


az acr identity assign \
--identities $IDENTITY_ID \
--name $REGISTRY_NAME \
--resource-group $RESOURCE_GROUP


az acr build \
-t $REGISTRY_NAME".azurecr.io/"$CONTAINER_APP_NAME":v1" \
-r $REGISTRY_NAME .


az containerapp create \
--name $CONTAINER_APP_NAME \
--resource-group $RESOURCE_GROUP \
--environment $ENVIRONMENT \
--image $REGISTRY_NAME".azurecr.io/"$CONTAINER_APP_NAME":v1" \
--target-port 8080 \
--ingress external \
--user-assigned $IDENTITY_ID \
--registry-identity $IDENTITY_ID \
--registry-server $REGISTRY_NAME.azurecr.io \
--min-replicas 1 \
--query properties.configuration.ingress.fqdn




GET https://apiequipment.proudbeach-0c95e7cc.eastus.azurecontainerapps.io/health
https://apiequipment.proudbeach-0c95e7cc.eastus.azurecontainerapps.io/health

=====coverage-service


az login --use-device-code
az extension add --name containerapp --upgrade

export LOCATION="eastus"
#Nombre de tu Resource Group en Azure asignado
export RESOURCE_GROUP="rg_Maria_Baute"
export IDENTITY_NAME="api-coverage-services-identity"
export ENVIRONMENT="flk-dev-acae"
export REGISTRY_NAME="flkdevacrepo"
export CONTAINER_APP_NAME="apicoverageservices"


az identity create \
--name $IDENTITY_NAME \
--resource-group $RESOURCE_GROUP


IDENTITY_ID=$(az identity show \
--name $IDENTITY_NAME \
--resource-group $RESOURCE_GROUP \
--query id \
--output tsv)

echo $IDENTITY_ID

//nooo
az containerapp env create \
--name $ENVIRONMENT \
--resource-group $RESOURCE_GROUP \
--location $LOCATION \
--mi-user-assigned $IDENTITY_ID

az acr create \
--resource-group $RESOURCE_GROUP \
--name $REGISTRY_NAME \
--sku Basic


az acr identity assign \
--identities $IDENTITY_ID \
--name $REGISTRY_NAME \
--resource-group $RESOURCE_GROUP


az acr build \
-t $REGISTRY_NAME".azurecr.io/"$CONTAINER_APP_NAME":v1" \
-r $REGISTRY_NAME .


az containerapp create \
--name $CONTAINER_APP_NAME \
--resource-group $RESOURCE_GROUP \
--environment $ENVIRONMENT \
--image $REGISTRY_NAME".azurecr.io/"$CONTAINER_APP_NAME":v1" \
--target-port 8080 \
--ingress external \
--user-assigned $IDENTITY_ID \
--registry-identity $IDENTITY_ID \
--registry-server $REGISTRY_NAME.azurecr.io \
--min-replicas 1 \
--query properties.configuration.ingress.fqdn

----- capacity service


az login --use-device-code
az extension add --name containerapp --upgrade

export LOCATION="eastus"
#Nombre de tu Resource Group en Azure asignado
export RESOURCE_GROUP="rg_Maria_Baute"
export IDENTITY_NAME="api-capacity-service-identity"
export ENVIRONMENT="flk-dev-acae"
export REGISTRY_NAME="flkdevacrepo"
export CONTAINER_APP_NAME="apicapacityservice"


az identity create \
--name $IDENTITY_NAME \
--resource-group $RESOURCE_GROUP


IDENTITY_ID=$(az identity show \
--name $IDENTITY_NAME \
--resource-group $RESOURCE_GROUP \
--query id \
--output tsv)

echo $IDENTITY_ID

//nooo
az containerapp env create \
--name $ENVIRONMENT \
--resource-group $RESOURCE_GROUP \
--location $LOCATION \
--mi-user-assigned $IDENTITY_ID

//noo
az acr create \
--resource-group $RESOURCE_GROUP \
--name $REGISTRY_NAME \
--sku Basic


az acr identity assign \
--identities $IDENTITY_ID \
--name $REGISTRY_NAME \
--resource-group $RESOURCE_GROUP


az acr build \
-t $REGISTRY_NAME".azurecr.io/"$CONTAINER_APP_NAME":v2" \
-r $REGISTRY_NAME .


az containerapp update \
--name $CONTAINER_APP_NAME \
--resource-group $RESOURCE_GROUP \
--environment $ENVIRONMENT \
--image $REGISTRY_NAME".azurecr.io/"$CONTAINER_APP_NAME":v2" \
--target-port 8080 \
--ingress external \
--user-assigned $IDENTITY_ID \
--registry-identity $IDENTITY_ID \
--registry-server $REGISTRY_NAME.azurecr.io \
--min-replicas 1 \
--query properties.configuration.ingress.fqdn



/////// Actualizar
export RESOURCE_GROUP="rg_Maria_Baute"
export REGISTRY_NAME="flkdevacrepo"
export CONTAINER_APP_NAME="apicapacityservice"

az acr build \
-t $REGISTRY_NAME.azurecr.io/$CONTAINER_APP_NAME:v4 \
-r $REGISTRY_NAME .


az containerapp update \
--name $CONTAINER_APP_NAME \
--resource-group $RESOURCE_GROUP \
--set-env-vars KEY_VAULT_URI=https://flkdevkv.vault.azure.net/ \
--image $REGISTRY_NAME.azurecr.io/$CONTAINER_APP_NAME:v3

--set-env-vars AZURE_CLIENT_ID=361cc176-381f-41f6-8b68-dbb8a4fc9c15

az containerapp update \
--name $CONTAINER_APP_NAME \
--resource-group $RESOURCE_GROUP \
--set-env-vars \
KEY_VAULT_URI=https://flkdevkv.vault.azure.net/ \
AZURE_CLIENT_ID=361cc176-381f-41f6-8b68-dbb8a4fc9c15 \
--image $REGISTRY_NAME.azurecr.io/$CONTAINER_APP_NAME:v4


az containerapp identity show \
--name $CONTAINER_APP_NAME \
--resource-group $RESOURCE_GROUP




az containerapp identity show \
--name $CONTAINER_APP_NAME \
--resource-group $RESOURCE_GROUP


az role assignment create \
--role "Key Vault Secrets User" \
--assignee 7b120235-df70-4c3e-9932-e1a5aee26521 \
--scope /subscriptions/088b9168-fdd5-4280-83de-02aaee8b9daf/resourceGroups/rg_Maria_Baute/providers/Microsoft.KeyVault/vaults/flkdevkv

az containerapp identity show \
--name $CONTAINER_APP_NAME \
--resource-group $RESOURCE_GROUP \
--query principalId \
-o tsv
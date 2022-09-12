RESOURCE_GROUP="sample-container-ae-app-rg"
LOCATION="australiaeast" #ensure the location supports container app service
LOG_ANALYTICS_WORKSPACE="sample-container-logs"
SUB_ID="418488cd-175d-40c4-a5ea-e6db608334cd"
CONTAINERAPPS_ENVIRONMENT="container-sample-env"

# Follow Azure CLI prompts to authenticate to your subscription of choice
az login
az account set --subscription $SUB_ID

# Create resource group
echo "Create Resource Group"
az group create --name $RESOURCE_GROUP --location $LOCATION --tags environment=workshop

# Create Azure Monitor Group
echo "Create Log Analystics"
az monitor log-analytics workspace create --resource-group $RESOURCE_GROUP --workspace-name $LOG_ANALYTICS_WORKSPACE

# obtain client_id and client_secret
LOG_ANALYTICS_WORKSPACE_CLIENT_ID=`az monitor log-analytics workspace show --query customerId -g $RESOURCE_GROUP -n $LOG_ANALYTICS_WORKSPACE --out tsv`
LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET=`az monitor log-analytics workspace get-shared-keys --query primarySharedKey -g $RESOURCE_GROUP -n $LOG_ANALYTICS_WORKSPACE --out tsv`


# create container app environment
echo "Create Container App"
az containerapp env create \
--name $CONTAINERAPPS_ENVIRONMENT \
--resource-group $RESOURCE_GROUP \
--logs-workspace-id $LOG_ANALYTICS_WORKSPACE_CLIENT_ID \
--logs-workspace-key $LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET \
--location "$LOCATION"

# deploy hello-world with ingress external.
echo "Deploy default container app"
az containerapp create \
  --name my-container-app \
  --resource-group $RESOURCE_GROUP \
  --environment $CONTAINERAPPS_ENVIRONMENT \
  --image mcr.microsoft.com/azuredocs/containerapps-helloworld:latest \
  --target-port 80 \
  --ingress 'external' \
  --revision-suffix 'rev1' \
  --query configuration.ingress.fqdn

az containerapp revision label add --name my-container-app --resource-group $RESOURCE_GROUP --label 'production' --revision 'my-container-app--rev1' --no-prompt --yes

echo "Deploy 2nd container app - Multiple revision"
az containerapp create \
  --name my-container-app-2 \
  --resource-group $RESOURCE_GROUP \
  --environment $CONTAINERAPPS_ENVIRONMENT \
  --image mcr.microsoft.com/azuredocs/containerapps-helloworld:latest \
  --target-port 80 \
  --ingress 'external' \
  --revisions-mode 'multiple' \
  --revision-suffix 'rev1' \
  --query configuration.ingress.fqdn

az containerapp revision label add --name my-container-app-2 --resource-group $RESOURCE_GROUP --label 'production' --revision 'my-container-app-2--rev1' --no-prompt --yes 

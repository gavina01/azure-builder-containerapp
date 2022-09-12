
# Azure CLI
# az login
# Azure Container Apps extension 
az extension add --name containerapp --upgrade
# Register namespace
az provider register --namespace Microsoft.App
# Check namespace
# az provider show -n Microsoft.App
# Azure Monitor Logs namespace
az provider register --namespace Microsoft.OperationalInsights
# setup persistent parameters
# az config param-persist on
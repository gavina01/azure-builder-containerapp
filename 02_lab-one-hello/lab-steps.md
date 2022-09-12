
## complete steps and outline of the lab

2.40
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash


az group create -n rg-aca -l northeurope

az deployment group create -n aca-deploy \
  -g rg-aca \
  --template-file ./main.bicep

  while true; do curl ; echo '1'; done;
  seq 1 200 | xargs -n1 -P20  curl "https://my-container-app.icysea-b8cb4aea.australiaeast.azurecontainerapps.io" > /dev/null
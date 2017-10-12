az group create -n hpctest -l "West Europe"
az group deployment create --resource-group hpctest --template-file bigcomputebench.json 
az vm list-ip-addresses

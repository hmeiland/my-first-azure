

az group create -n osimages -l westeurope
az vm create -g osimages -n compnode --image OpenLogic:CentOS-HPC:7.1:latest --size Standard_H16r --storage-sku Standard_LRS
az vm list-ip-addresses
az vm list-ip-addresses | grep ipAddress | awk -F "\"" '{print $4}'

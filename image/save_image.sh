
az vm deallocate -g osimages -n compnode
az vm generalize -g osimages -n compnode
az image create -g osimages -n centos71hpc --source compnode  
az image list --output table


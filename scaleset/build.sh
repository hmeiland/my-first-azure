az group create -n hpccluster -l westeurope

#b) Create a VM scale set of e.g. 4 H16r nodes using the custom OS image:
az vmss create -n vmsscluster -g hpccluster \
	--vm-sku Standard_H16r \
	--instance-count 2 \
	--disable-overprovision \
	--image OpenLogic:CentOS-HPC:7.1:7.1.20170608 
	#--image "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/osimages/providers/Microsoft.Compute/images/centos71hpc" 
#[Note that we also use the default SSH authentication here – no user/password]

#c) Display access information to cluster nodes:
#az vmss list-instance-connection-info -n vmsscluster -g hpccluster



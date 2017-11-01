az group create -n hpccluster -l westeurope

time az vmss create -n vmsscluster -g hpccluster \
	--vm-sku Standard_H16r \
	--instance-count 2 \
	--disable-overprovision \
	--image OpenLogic:CentOS-HPC:7.1:7.1.20170608 \
	#--data-disk-sizes-gb 1024 1024 1024 1024 1024 1024 

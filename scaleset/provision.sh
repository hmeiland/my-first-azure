
ssh-keygen -t dsa -f ./testcluster.key -P ""

export SSH_IP=`az vmss list-instance-connection-info -n vmsscluster -g testcluster | grep instance | awk -F "\"" '{print $4}' | awk -F ":" '{print $1}' | uniq`
export SSH_PORTS=`az vmss list-instance-connection-info -n vmsscluster -g testcluster | grep instance | awk -F "\"" '{print $4}' | awk -F ":" '{print $2}'`

echo "ssh ip address is $SSH_IP"


for i in $SSH_PORTS; do
  echo $i
done

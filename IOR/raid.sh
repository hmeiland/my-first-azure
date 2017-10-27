DISKS=`ls /dev/sd* | grep -v sda | grep -v sdb`

echo $DISKS

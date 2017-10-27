DISKS=`ls /dev/sd* | grep -v sda | grep -v sdb`
NUMDISKS=`echo $DISKS | wc -w`
echo $DISKS $NUMDISKS

sudo mdadm --create --verbose /dev/md0 --level=0 --raid-devices=$NUMDISKS $DISKS
sudo mkfs.ext4 /dev/md0
sudo mount /dev/md0 /mnt/resource
sudo chmod 777 /mnt/resource

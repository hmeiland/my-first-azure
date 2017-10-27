DISKS=`ls /dev/sd* | grep -v sda | grep -v sdb`
NUMDISKS=`echo $DISKS | wc`
echo $DISKS $NUMDISKS

echo sudo mdadm --create --verbose /dev/md0 --level=0 --raid-devices=2 /dev/sda /dev/sdb

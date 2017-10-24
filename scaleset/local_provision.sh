

yum -y install git nfs-utils


git clone https://github.com/hmeiland/my-first-azure
cd my-first-azure/HPL

echo "source ~/my-first-azure/HPL/env.sh" >> /etc/bashrc

if [ `hostname -s` == "node1" ]; then

echo "I am node1!!!"
echo "/opt 10.0.0.0/16(rw)" > /etc/exports
sudo service nfs restart 
./build.sh
fi


if [ `hostname -s` != "node1" ]; then

mount 10.0.0.4:/opt /opt
./build.sh
fi



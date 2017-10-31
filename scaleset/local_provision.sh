

sudo yum -y install git nfs-utils


sudo -u hugo git clone https://github.com/hmeiland/my-first-azure
cd my-first-azure/HPL

sudo echo "source ~/my-first-azure/HPL/env.sh" >> /etc/bashrc
sudo echo "export I_MPI_FABRICS=dapl I_MPI_DAPL_PROVIDER=ofa-v2-ib0 I_MPI_DYNAMIC_CONNECTION=0" >> /etc/bashrc

if [ `hostname -s` == "node1" ]; then

echo "I am node1!!!"
sudo echo "/opt 10.0.0.0/16(rw)" > /etc/exports
sudo echo "/home 10.0.0.0/16(rw)" >> /etc/exports
sudo service nfs restart 
./build.sh
fi


if [ `hostname -s` != "node1" ]; then
sudo mount 10.0.0.4:/opt /opt
./build.sh
fi



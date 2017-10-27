if [ ! -e /opt/intel/compilers_and_libraries_2018.0.128/linux/mpi/intel64/bin/mpivars.sh ]
then         
  echo "downloading and installing Intel MPI"
  wget -q http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/12120/l_mpi_2018.0.128.tgz
  tar zxf l_mpi_2018.0.128.tgz
  cd l_mpi_2018.0.128
cat >> my.silent.cfg << EOF
# Accept EULA, valid values are: {accept, decline}
ACCEPT_EULA=accept
# Optional error behavior, valid values are: {yes, no}
CONTINUE_WITH_OPTIONAL_ERROR=yes
# Install location, valid values are: {/opt/intel, filepat}
PSET_INSTALL_DIR=/opt/intel
# Continue with overwrite of existing installation directory, valid values are: {yes, no}
CONTINUE_WITH_INSTALLDIR_OVERWRITE=yes
# List of components to install, valid values are: {ALL, DEFAULTS, anythingpat}
COMPONENTS=DEFAULTS
# Installation mode, valid values are: {install, repair, uninstall}
PSET_MODE=install
# Directory for non-RPM database, valid values are: {filepat}
#NONRPM_DB_DIR=filepat
# Path to the cluster description file, valid values are: {filepat}
#CLUSTER_INSTALL_MACHINES_FILE=filepat
# Perform validation of digital signatures of RPM files, valid values are: {yes, no}
SIGNING_ENABLED=yes
# Select target architecture of your applications, valid values are: {IA32, INTEL64, ALL}
ARCH_SELECTED=ALL
EOF
  sudo ./install.sh --silent ./my.silent.cfg
  cd ..
  rm -rf l_mpi_2018.0.128 l_mpi_2018.0.128.tgz
fi
#wget -q http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/12058/parallel_studio_xe_2018_cluster_edition.tgz


echo "cloning and building IOR..."
#sudo yum -y install automake gcc
#git clone https://github.com/hmeiland/ior
#cd ior
#./bootstrap.sh
sudo chmod 777 /mnt/resource
. /opt/intel/compilers_and_libraries_2018.0.128/linux/mpi/intel64/bin/mpivars.sh
echo "you can now run with:"
echo "mpirun ./bin/ior -f ior-script.txt"



if [ ! -e /opt/intel/compilers_and_libraries_2018.0.128/linux/mpi/intel64/bin/mpivars.sh ]
then
  echo "downloading and unpacking Intel MPI"
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
  echo "installing Intel MPI..."
  sudo ./install.sh --silent ./my.silent.cfg
  cd ..
  rm -rf l_mpi_2018.0.128 l_mpi_2018.0.128.tgz
fi

if [ ! -e /opt/intel/compilers_and_libraries/linux/mkl/benchmarks/mp_linpack/xhpl_intel64_static ]
then 
  echo "downloading and unpacking Intel MKL"
  wget -q http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/12070/l_mkl_2018.0.128.tgz
  tar zxf l_mkl_2018.0.128.tgz
  cd l_mkl_2018.0.128
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
  echo "installing Intel MKL..."
  sudo ./install.sh --silent ./my.silent.cfg
  cd ..
  rm -rf l_mkl_2018.0.128 l_mkl_2018.0.128.tgz
fi

CPU=`cat /proc/cpuinfo  | grep "model name" | uniq | awk '{ $1=""; $2=""; $3=""; print }' | awk '{$1=$1}1'`
# From Intel MKL Linpack Readme:
#Blocking size (NB) recommendation
#---------------------------------
#
#Recommended blocking sizes (NB in HPL.dat) are listed below for various Intel(R)
#architectures:
#
#Intel(R) Xeon(R) Processor X56*/E56*/E7-*/E7*/X7*                             : 256
#Intel(R) Xeon(R) Processor E26*/E26* v2                                       : 256
#Intel(R) Xeon(R) Processor E26* v3/E26* v4                                    : 192
#Intel(R) Core(TM) i3/5/7-6* Processor                                         : 192
#Intel(R) Xeon Phi(TM) Processor 72*                                           : 336
#Intel(R) Xeon(R) Processor supporting Intel(R) Advanced Vector Extensions 512
#         (Intel(R) AVX-512) (codename Skylake Server)                         : 384
#
echo "I've found this cpu: $CPU"
NB=192; OPS=16;
if [[ $CPU =~ "Intel(R) Xeon(R) CPU E5-2673 v4 @ 2.30GHz" ]] ; then
  NB=192
  OPS=16
fi
if [[ $CPU =~ "Intel(R) Xeon(R) CPU E5-2673 v3 @ 2.40GHz " ]] ; then
  NB=192
  OPS=8
fi
if [[ $CPU =~ "Intel(R) Core(TM) i7-6650U CPU @ 2.20GHz" ]] ; then
  NB=192
  OPS=16
fi

CORES=`cat /proc/cpuinfo | grep processor | wc -l`
MHZ=`cat /proc/cpuinfo | grep "cpu MHz" | uniq | awk '{ print $4}'`
echo "I see $CORES cores, each running at $MHZ MHz"
SOCKET=`lscpu | grep "Socket(s):" | awk '{print $2}'`
CPS=`lscpu | grep "Core(s) per socket:" | awk '{print $4}'`
REAL_CORES=`echo "scale=0; $SOCKET * $CPS" | bc`
FLOPS=`echo "scale=0; (1 *( $REAL_CORES * $MHZ * $OPS ) )/1000" | bc`
echo "but I do not trust the OS, looks more like $REAL_CORES real cores" 
echo "so the theoretical peak performance will be around $FLOPS GFLOPS"


echo "for this cpu, the best NB = $NB"

# find amount of real memory
MEM=`free | grep Mem | awk -e '{ print $2 }'`
MEM_GB=`free -g | grep Mem | awk -e '{ print $2 }'`
echo "I've found $MEM KB of memory or roughly $MEM_GB GB ..."
NODES=1
#sqrt((Memory Size in Gbytes * 1024 * 1024 * 1024 * Number of Nodes) /8) * 0.90 
USE_N=`echo "scale=0; (9 * (sqrt( ($MEM * 1024 * $NODES)/8) ) ) / 10 " | bc `
echo "I can probably use a problem size of N = $USE_N ..."


DIV_N_NB=`echo "scale=0; ($USE_N / $NB) " | bc`
BEST_N=`echo "scale=0; ($DIV_N_NB * $NB) " | bc`
echo "my best N for NB = $NB will be N = $BEST_N" 

cat >HPL.dat <<EOF
HPLinpack benchmark input file
Innovative Computing Laboratory, University of Tennessee
HPL.out      output file name (if any)
6            device out (6=stdout,7=stderr,file)
1            # of problems sizes (N)
$BEST_N      Ns
1            # of NBs
$NB          NBs
1            PMAP process mapping (0=Row-,1=Column-major)
1            # of process grids (P x Q)
1 2          Ps
1 2          Qs
16.0         threshold
1            # of panel fact
2 1 0        PFACTs (0=left, 1=Crout, 2=Right)
1            # of recursive stopping criterium
2            NBMINs (>= 1)
1            # of panels in recursion
2            NDIVs
1            # of recursive panel fact.
1 0 2        RFACTs (0=left, 1=Crout, 2=Right)
1            # of broadcast
0            BCASTs (0=1rg,1=1rM,2=2rg,3=2rM,4=Lng,5=LnM)
1            # of lookahead depth
0            DEPTHs (>=0)
0            SWAP (0=bin-exch,1=long,2=mix)
1            swapping threshold
1            L1 in (0=transposed,1=no-transposed) form
1            U  in (0=transposed,1=no-transposed) form
0            Equilibration (0=no,1=yes)
8            memory alignment in double (> 0)
EOF
cp /opt/intel/compilers_and_libraries/linux/mkl/benchmarks/mp_linpack/xhpl_intel64_static .
echo "I'm done building the HPL.dat (and copied the benchmark locally)"
echo "you can just start with ./xhpl_intel64_static; have fun!"

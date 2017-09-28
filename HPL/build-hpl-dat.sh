
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
if [[ $CPU =~ "Intel(R) Xeon(R) CPU E5-2673 v4 @ 2.30GHz" ]] ; then
  NB=192
fi
if [[ $CPU =~ "Intel(R) Core(TM) i7-6650U CPU @ 2.20GHz" ]] ; then
  NB=192
fi
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

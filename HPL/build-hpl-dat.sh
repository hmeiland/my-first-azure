
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
echo "I'm done building the HPL.dat"


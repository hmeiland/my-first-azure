
# find amount of real memory
MEM=`free | grep Mem | awk -e '{ print $2 }'`
MEM_GB=`free -g | grep Mem | awk -e '{ print $2 }'`
echo "I've found $MEM KB of memory or roughly $MEM_GB GB ..."
NODES=1
#sqrt((Memory Size in Gbytes * 1024 * 1024 * 1024 * Number of Nodes) /8) * 0.90 
USE_MEM=`echo "scale=0; (9 * (sqrt( ($MEM * 1024 * $NODES)/8) ) ) / 10 " | bc `
echo "I can probably use a problem size of NB = $USE_MEM ..."

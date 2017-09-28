
# find amount of real memory
MEM=`free -g | grep Mem | awk -e '{ print $2 }'`
echo "I've found $MEM GB of memory..."

USE_MEM=`echo "0.8*$MEM" | bc`
echo "I can probably use about $USE_MEM GB"

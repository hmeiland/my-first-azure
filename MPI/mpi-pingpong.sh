#!/bin/bash
#$ -l slot_type=execute,affinity_group=default
#$ -pe mpi 32

export INTELMPI_ROOT=/opt/intel/impi/2017.2.174
export I_MPI_FABRICS=shm:dapl
export I_MPI_DAPL_PROVIDER=ofa-v2-ib0
export I_MPI_ROOT=/opt/intel/compilers_and_libraries_2017.2.174/linux/mpi
source /opt/intel/impi/2017.2.174/bin64/mpivars.sh

cat "$TMPDIR/machines"
cat "$PE_HOSTFILE"

for i in `seq 1 $PPN`;
do
  uniq $TMPDIR/machines >> $TMPDIR/u_machines
done

echo Run a “ping-pong” test over RDMA:
time mpirun -machinefile "$TMPDIR/u_machines" IMB-MPI1 pingpong

echo Run a “ping-pong” test over TCP:
export I_MPI_FABRICS=tcp
time mpirun -machinefile "$TMPDIR/u_machines" IMB-MPI1 pingpong

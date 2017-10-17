
wget http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.8.0.tar.gz
tar zxf petsc-lite-3.8.0.tar.gz

cd petsc-3.8.0 

export PETSC_DIRS=`pwd`
export PETSC_ARCH=linux-gnu-intel
export CPATH=$CPATH:/opt/intel/compilers_and_libraries_2018.0.128/linux/mpi/intel64/include 
./configure --with-blas-lapack-dir=$MKLROOT
make PETSC_DIR=/home/hugo/my-first-azure/libs/PETSc/petsc-3.8.0 PETSC_ARCH=linux-gnu-intel all
make PETSC_DIR=/home/hugo/my-first-azure/libs/PETSc/petsc-3.8.0 PETSC_ARCH=linux-gnu-intel test
make PETSC_DIR=/home/hugo/my-first-azure/libs/PETSc/petsc-3.8.0 PETSC_ARCH=linux-gnu-intel streams 


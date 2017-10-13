

wget --no-check-certificate http://trilinos.org/oldsite/download/files/trilinos-11.12.1-Source.tar.bz2
tar xfj trilinos-11.12.1-Source.tar.bz2

CC=`which icc` FC=`which ifort` CXX=`which icpc` cmake \
-D CMAKE_CXX_FLAGS:STRING=" -DMPICH_IGNORE_CXX_SEEK -DMPICH_SKIP_MPICXX" \
-D CMAKE_BUILD_TYPE:STRING=RELEASE \
-D CMAKE_VERBOSE_MAKEFILE:BOOL=ON \
-D Trilinos_VERBOSE_CONFIGURE:BOOL=ON \
-D TPL_ENABLE_MPI=ON \
-D MPI_BASE_DIR=/opt/intel/impi/4.1.3.045/intel64 \
-D MPI_C_COMPILER:FILEPATH=mpiicc \
-D MPI_CXX_COMPILER:FILEPATH=mpiicpc \
-D MPI_Fortran_COMPILER:FILEPATH=mpiifort \
-D Trilinos_ENABLE_ALL_PACKAGES=ON \
-D BLAS_INCLUDE_DIRS:PATH=$MKLROOT/include/ \
-D BLAS_LIBRARY_DIRS:PATH=$MKLROOT/lib/intel64/ \
-D LAPACK_LIBRARY_DIRS:PATH=$MKLROOT/lib/intel64/ \
-D BLAS_LIBRARY_NAMES:STRING="mkl_intel_lp64;mkl_core;mkl_sequential" \
-D LAPACK_LIBRARY_NAMES:STRING="mkl_intel_lp64;mkl_core;mkl_sequential" \
-D BUILD_SHARED_LIBS:BOOL=ON \
-D CMAKE_INSTALL_PREFIX=~/trilinos-11.12.1 \
./trilinos-11.12.1-Source

make -j8 
#$ make -j8 install


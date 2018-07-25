FROM centos:7
WORKDIR /app
ADD intel.tgz /opt/
RUN yum install -y wget tar gzip libmlx4 librdmacm libibverbs dapl rdma net-tools numactl
RUN wget https://github.com/firemodels/fds/releases/download/FDS6.6.0/FDS_6.6.0-SMV_6.6.0_linux64.sh && \
    chmod +x FDS_6.6.0-SMV_6.6.0_linux64.sh && \
    ./FDS_6.6.0-SMV_6.6.0_linux64.sh y && rm -f ./FDS_6.6.0-SMV_6.6.0_linux64.sh && mv /root/FDS /usr/local/
ENV LD_LIBRARY_PATH /opt/intel/compilers_and_libraries_2016.3.223/linux/mpi/intel64/lib/
ENV LD_LIBRARY_PATH /usr/lib64:/usr/local/FDS/FDS6/bin/LIB64:$LD_LIBRARY_PATH
ENV PATH /usr/local/FDS/FDS6/bin:$PATH
ENTRYPOINT "$@"


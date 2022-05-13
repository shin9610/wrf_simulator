FROM ubuntu:18.04 AS development

RUN apt update && apt-get update && apt-get upgrade

RUN apt install -y gfortran-8
RUN apt install -y m4
RUN apt install -y libnetcdf-dev
RUN apt install -y netcdf-bin
RUN apt install -y mpich
RUN apt install -y libpng-dev
RUN apt install -y ncl-ncarg
# RUN apt install -y libcurl

WORKDIR /usr/local/wrf_simulator

# install netCDF
# - install zlib
WORKDIR /usr/local/wrf_simulator
COPY zlib-1.2.12/ ./zlib-1.2.12
WORKDIR /usr/local/wrf_simulator/zlib-1.2.12
RUN ./configure --prefix=/usr/local
RUN make
RUN make install

# - install szip
WORKDIR /usr/local/wrf_simulator
COPY szip-2.1.1/ ./szip-2.1.1
WORKDIR /usr/local/wrf_simulator/szip-2.1.1
RUN ./configure --prefix=/usr/local
RUN make
RUN make install

# - install hdf5
WORKDIR /usr/local/wrf_simulator
COPY hdf5-1.12.0/ ./hdf5-1.12.0
WORKDIR /usr/local/wrf_simulator/hdf5-1.12.0
RUN ./configure --enable-fortran --with-szlib=/usr/local --enable-threadsafe --with-pthread=/usr/include/,/usr/lib/x86_64-linux-gnu --enable-hl --enable-shared --enable-unsupported --prefix=/usr/local/hdf5-1.12.0
RUN make
RUN make check
RUN make install

# install WRF WPS
COPY WPS/ ./WPS
COPY WRF/ ./WRF

# setting env var
RUN export FC=gfortran
RUN export CC=gcc
RUN export CPATH=$CPATH:/usr/local/hdf5/include
RUN export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/hdf5/lib

# install netcdf
WORKDIR /usr/local/wrf_simulator
COPY netcdf-c-4.8.1/ ./netcdf-c-4.8.1
WORKDIR /usr/local/wrf_simulator/netcdf-c-4.8.1
RUN export NCDIR=/usr/local/netcdf-c-4.8.1
RUN export CPPFLAGS="-I/usr/local/include -I/usr/local/hdf5/include"
RUN export LDFLAGS="-L/usr/local/lib -L/usr/local/hdf5/lib"

# RUN ./configure --prefix=${NCDIR} --enable-netcdf-4 --enable-shared --enable-dap --disable-dap-remote-tests --with-curl=/usr/include/x86_64-linux-gnu/curl
RUN ./configure --prefix=/usr/local/netcdf-c-4.8.1 --enable-netcdf-4 --enable-shared --enable-dap --disable-dap-remote-tests --with-curl=/usr/include/x86_64-linux-gnu/curl
RUN make
RUN check
RUN make install

FROM ubuntu:18.04 AS development

RUN apt-get update && apt-get upgrade

RUN apt install -y gfortran-8
RUN apt install -y m4
RUN apt install -y libnetcdf-dev
RUN apt install -y netcdf-bin
RUN apt install -y mpich
RUN apt install -y libpng-dev
RUN apt install -y ncl-ncarg

WORKDIR /usr/local/wrf_simulator

# install netCDF
# - install zlib
WORKDIR /usr/local/wrf_simulator
COPY zlib-1.2.12/ ./zlib-1.2.12
WORKDIR /usr/local/wrf_simulator/zlib-1.2.12
# RUN ./configure
# RUN make
# RUN make install

# - install szip
WORKDIR /usr/local/wrf_simulator
COPY 

# install WRF WPS
# COPY WPS/ ./WPS
# COPY WRF/ ./WRF

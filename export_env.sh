#!/bin/bash

CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export DIR=$CUR_DIR/Build_WRF/LIBRARIES
export CC=gcc
export CXX=g++
export FC=gfortran
export FCFLAGS=-m64
export F77=gfortran
export FFLAGS=-m64
export DIR CC CXX FC FCFLAGS F77 FFLAGS

export LDFLAGS=-L$DIR/grib2/lib
export CPPFLAGS=-I$DIR/grib2/include
export LDFLAGS CPPFLAGS

export PATH=$DIR/netcdf/bin:$PATH
export NETCDF=$DIR/netcdf
export PATH NETCDF

export PATH=$DIR/mpich/bin:$PATH
export PATH

export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include
export JASPERLIB JASPERINC
export LD_LIBRARY_PATH=$DIR/grib2/lib
export LD_LIBRARY_PATH

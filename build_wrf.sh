#!/bin/bash


# # dir where this build_wrf exist.
#CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CUR_DIR="$(pwd)"
export DIR=$CUR_DIR/Build_WRF/LIBRARIES   # here, no space arount the '='
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
export PATH NETCDF               # here, it seems export path twice, likely not necceary, but as it be.

export PATH=$DIR/mpich/bin:$PATH
export PATH

export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include
export JASPERLIB JASPERINC
export LD_LIBRARY_PATH=$DIR/grib2/lib
export LD_LIBRARY_PATH


mkdir ./Build_WRF  # not neccery.
cd  ./Build_WRF

### installing dependese packages ###
# # ./Build_WRF
yum install -y  gfortran
yum install -y  gcc
yum install -y  cpp
yum install libgfortran
yum install gcc-c++
yum install gcc-gfortran
# need csh, sh and perl
yum install -y  csh
yum install -y  perl

# error on some not found command, time? try yum install time.
yum install time    # needed by build_wrf(not essential, maybe)


# download and unpack wrfv3
echo downloading wrfv3
wget http://www2.mmm.ucar.edu/wrf/src/WRFV3.7.TAR.gz
gunzip WRFV3.7.TAR.gz
tar -xf WRFV3.7.TAR
# downlaod wpsv3
wget http://www2.mmm.ucar.edu/wrf/src/WPSV3.7.TAR.gz
gunzip WPSV3.7.TAR.gz
tar -xf WPSV3.7.TAR
download geographical input  data.

mkdir WPS_GEOG
cd WPS_GEOG
# this tar file will not creat a folder.
wget http://www2.mmm.ucar.edu/wrf/src/wps_files/geog_complete.tar.bz2 -O geog.tar.bz2
# wget http://www2.mmm.ucar.edu/wrf/src/wps_files/geog_minimum.tar.bz2 -O geog.tar.bz2
tar -xf geog.tar.bz2
# mv geog WPS_GEOG
cd ..

# minimum data set need this input.wps list
# wget http://www2.mmm.ucar.edu/wrf/src/wps_files/namelist.wps.low_res -O namelist.wps
# here is full geog data link.
# wget http://www2.mmm.ucar.edu/wrf/src/WRFV3.7.TAR.gz
# wget file:///home/lcg/pro/src/wps_files/geog_new3.8.tar.bz2
# wget http://www2.mmm.ucar.edu/wrf/src/wps_files/geog_new3.8.tar.bz2
# wget http://www2.mmm.ucar.edu/wrf/src/wps_files/geog_complete.tar.bz2
# in configure.wps, there is a line, like this: "GEOG_DATA_PATH=$DIR/../WPS_GEOG"
# should use sed
### end of installing dependense packages ###


### building LIBRSRIES ###
mkdir ./LIBRARIES
cd   LIBRARIES
# # ./Build_WRF/LIBRARIES
# downloading, should be pass after check local packages(in furture).
# libaries tar.
wget http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_tests.tar
wget http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/netcdf-4.1.3.tar.gz
wget http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz
wget http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/mpich-3.0.4.tar.gz
wget http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/libpng-1.2.50.tar.gz
wget http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/zlib-1.2.7.tar.gz
# unpack all
tar xzvf netcdf-4.1.3.tar.gz; tar zxfv zlib-1.2.7.tar.gz; tar zxfv libpng-1.2.50.tar.gz; tar zxvf jasper-1.900.1.tar.gz; tar xzvf mpich-3.0.4.tar.gz
# fortran and c test tar

# # next should be some test process, but not familar with bash if/else, so skip this and assume test passed.
# # 1, install it one by one.
# # # export some envirment.

cd $DIR
# netcdf
# echo installing netcdf
cd netcdf-4.1.3
./configure --prefix=$DIR/netcdf --disable-dap --disable-netcdf-4 --disable-shared
make
make install
cd ..

# mpich
# echo installing mpich
cd mpich-3.0.4
./configure --prefix=$DIR/mpich
make
make install
cd ..

# zlib
installing zlib
cd zlib-1.2.7
./configure --prefix=$DIR/grib2
make
make install
cd ..

# libpng
# echo installing libpng
cd libpng-1.2.50
./configure  --prefix=$DIR/grib2
make
make install
cd ..

# jasper
# echo installing jasper
cd jasper-1.900.1
./configure --prefix=$DIR/grib2
make
make install
cd ..

# library test package. pass by for now. TODO: test the libary
mkdir test
cd test
wget http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_NETCDF_MPI_tests.tar
# get out of test folder
cd ..
# cd out of LIBRARY folder.
cd ..
### end of building LIBRARY ###


### compiling wrf and wps ###
# build wrf3.7
cd WRFV3
# in the precheck step, it will need netcdf folder.
echo '34\n1' | ./configure   # 34 for dmpar and gfortran/gcc. and 1 for nesting.
# # compile type option.
# em_real (3d real case)
# em_quarter_ss (3d ideal case)
# em_b_wave (3d ideal case)
# em_les (3d ideal case)
# em_heldsuarez (3d ideal case)
# em_tropical_cyclone (3d ideal case)
# em_hill2d_x (2d ideal case)
# em_squall2d_x (2d ideal case)
# em_squall2d_y (2d ideal case)
# em_grav2d_x (2d ideal case)
# em_seabreeze2d_x (2d ideal case)
# em_scm_xy (1d ideal case)
./compile em_real >& log.compile
# about 30 minutes.
# test: under command ls -ls main/*.exe, should see wrf.exe, real.exe, ndown.exe, tc.exe(real case)
# TODO: must build this before wps.
cat log.compile | grep error
cd ..


# build wpsv3
cd WPS
./clean
echo '3\n1' | ./configure      # 3 for configure type(gfortran, dpmar), 1 for nesting option.
./compile >& log.compile
# use new Vtable.GFS
cp $CUR_DIR/Vtable.GFS.new  $CUR_DIR/Build_WRF/run_wrf/Vtable.GFS
# TODO: test, should have 3 exe file with this command: ls -ls *.exe
# if use minimum geog dataset, will use this namelist.
# mv namelist.wps namelist.wps.ori.old
# mv ../namelist.wps  ./
sed -i -e "s|geog_data_path=.*|geog_data_path=$GEOG_DATA_PATH|"  ./namelist.wps
cat log.compile |grep error

echo 'please double check wps/namelist.wps geog_data_path setting.'
cat  ./namelist.wps | grep geog_data_path
cd ..
### end compiling wrf and wps


# add startup
touch ./start_wrf.sh
echo "#!/bin/bash" >> ./start_wrf.sh
echo "cd $CUR_DIR; source export_env.sh" >> ./start_wrf.sh
echo "cd $CUR_DIR/Build_WRF/run_wrf" >> ./start_wrf.sh
echo "nohup python ./httpdownload_gfs.py >/dev/null &" >> ./start_wrf.sh
echo "nohup python ./inverse_wps.py >/dev/null &" >> ./start_wrf.sh
echo "nohup python ./inverse_wrf.py >/dev/null &" >> ./start_wrf.sh
chmod 755 ./start_wrf.sh

useradd wrf
chown -Rh wrf:wrf /home/wrf/
ln -sv $CUR_DIR/start_wrf.sh /etc/rc.d/
chmod 755 /etc/rc.d/start_wrf.sh
echo "here is all the script. "
echo " now should reboot"
# end of the script.

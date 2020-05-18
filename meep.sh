#!/bin/bash
# Auther: yiloong
# Date: 2019-07-18
# Ver: 1.3.2
# Build meep all in one folder. Need g++ gfortran and pkg-config.
# Changes in 1.3.2: MEEP_VER="1.10.0" MPB_VER="1.9.0"
# Changes in 1.3.1: libpng security.
# Changes in 1.3: add libctl version.
# Changes in 1.2: add zlib. Remove 'cp tar file'. Add timer.
# Changes in 1.1: Fix 'invalid opcode ip' by building m4, libtool and gmp with static. Fix swig build by pcre.

set -e

# build env
MEEP_VER="1.10.0"
MPB_VER="1.9.0"
LIBCTL_VER="4.3.0"
START_TIME=$(date +%s)
# path
BUILD_PATH=$PWD
#DOWN_PATH="${HOME}/Downloads/packages/src/meep"
DOWN_PATH="${HOME}/pkgs"
MEEP_PATH="${HOME}/opt/meep-$MEEP_VER"
#MEEP_PATH="$PWD/meepout"

RPATH_FLAGS="-Wl,-rpath,${MEEP_PATH}/lib"
MY_LDFLAGS="-L${MEEP_PATH}/lib ${RPATH_FLAGS}"
MY_CPPFLAGS="-I${MEEP_PATH}/include"
export PATH="${MEEP_PATH}/bin:$PATH"
#export LD_LIBRARY_PATH="${MEEP_PATH}/lib64:$LD_LIBRARY_PATH"

mkdir -p ${MEEP_PATH}
# gcc
# apt install  
#===g++ gfortran===
#g++ g++-7 gcc gcc-7 gfortran gfortran-7 libasan4 libatomic1 libc-dev-bin libc6-dev libcilkrts5 libgcc-7-dev libgfortran-7-dev libitm1 liblsan0 libmpx2 libstdc++-7-dev libtsan0 libubsan0 linux-libc-dev manpages-dev #zlib1g-dev 
#build-essential dpkg-dev fakeroot libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl libfakeroot pkg-config
#cd ..
#rm -r $MEEP_PATH
#echo "tar xf $DOWN_PATH/gcc-7.4.0.tar.xz"
#tar xf $DOWN_PATH/gcc-7.4.0.tar.xz
#mv gcc-7.4.0 ${MEEP_PATH}
#cd $MEEP_PATH
#tar xf $DOWN_PATH/gcc-4.8-infrastructure.tar.xz
#cd $BUILD_PATH

# blas
cd $MEEP_PATH
echo "tar xf $DOWN_PATH/blas-gdsii-1804.tar.gz"
tar xf $DOWN_PATH/blas-gdsii-1804.tar.gz

#make
#mv blas_LINUX.a libblas.a
#mv libblas.a ${MEEP_PATH}/lib/

# lapack
#mv make.inc.example make.inc
#export BLAS=${MEEP_PATH}/lib/libblas.a
#make lapacklib
#mv liblapack.a ${MEEP_PATH}/lib/

# zlib
cd $BUILD_PATH
tar xf $DOWN_PATH/zlib-1.2.11.tar.gz
cd ./zlib-1.2.11
./configure --prefix=${MEEP_PATH}
make -j4
make install

# libunistring
cd $BUILD_PATH
tar xf $DOWN_PATH/libunistring-0.9.10.tar.xz
cd ./libunistring-0.9.10
./configure --prefix=${MEEP_PATH} --enable-static LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}"
make -j4
make install

# m4
cd $BUILD_PATH
tar xf $DOWN_PATH/m4-1.4.18.tar.xz
cd ./m4-1.4.18
./configure --enable-static --prefix=${MEEP_PATH} LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}"
make -j4
make install

# libtool(libltdl) need m4
cd $BUILD_PATH
tar xf $DOWN_PATH/libtool-2.4.6.tar.xz
cd ./libtool-2.4.6
./configure --enable-static --prefix=${MEEP_PATH} LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}"
make -j4
make install

# libffi
cd $BUILD_PATH
tar xf $DOWN_PATH/libffi-3.2.1.tar.gz
cd ./libffi-3.2.1
./configure --prefix=${MEEP_PATH} --enable-static LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}"
make -j4
make install

# pcre
cd $BUILD_PATH
tar xf $DOWN_PATH/pcre-8.43.tar.gz
cd ./pcre-8.43
./configure --enable-static --prefix=${MEEP_PATH} LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}"
make -j4
make install

# gmp need libltdl-dev
cd $BUILD_PATH
tar xf $DOWN_PATH/gmp-6.1.2.tar.xz
cd ./gmp-6.1.2
./configure --prefix=${MEEP_PATH} --enable-static LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}"
make -j4
make install

# fftw
cd $BUILD_PATH
tar xf $DOWN_PATH/fftw-3.3.8.tar.gz
cd ./fftw-3.3.8
./configure --prefix=${MEEP_PATH} --enable-static --enable-shared LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}"
make -j4
make install

# swig need pcre
cd $BUILD_PATH
tar xf $DOWN_PATH/swig-3.0.12.tar.gz
cd ./swig-3.0.12
./configure --prefix=${MEEP_PATH} --enable-static
make -j4
make install

# libgsl
cd $BUILD_PATH
tar xf $DOWN_PATH/gsl-2.5.tar.gz
cd ./gsl-2.5
./configure --prefix=${MEEP_PATH} --enable-static LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}"
make -j4
make install

# libpng need zlib1g-dev
cd $BUILD_PATH
tar xf $DOWN_PATH/libpng-1.6.37.tar.xz
cd ./libpng-1.6.37
./configure --prefix=${MEEP_PATH} --enable-static LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}"
make -j4
make install

# openmpi
cd $BUILD_PATH
tar xf $DOWN_PATH/openmpi-2.1.6.tar.gz
cd ./openmpi-2.1.6
./configure --enable-static --prefix=${MEEP_PATH} --without-verbs LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}"
make -j8
make install

#hdf5
cd $BUILD_PATH
tar xf $DOWN_PATH/hdf5-1.10.4.tar.gz
cd ./hdf5-1.10.4
./configure CC=mpicc CXX=mpic++ LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}" --enable-parallel --prefix=${MEEP_PATH} --enable-static
make -j4
make install

# libatomic
cd $BUILD_PATH
tar xf $DOWN_PATH/libatomic_ops-7.4.14.tar.gz
cd ./libatomic_ops-7.4.14
./configure --prefix=${MEEP_PATH} --enable-static LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}"
make -j4
make install

# bdw-gc
cd $BUILD_PATH
tar xf $DOWN_PATH/gc-8.0.4.tar.gz
cd ./gc-8.0.4
./configure --prefix=${MEEP_PATH} --enable-static LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}"
make -j4
make install

# guile
cd $BUILD_PATH
tar xf $DOWN_PATH/guile-2.0.14.tar.xz
cd ./guile-2.0.14
./configure --prefix=${MEEP_PATH} --enable-static LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}" LIBFFI_CFLAGS="-I${MEEP_PATH}/lib/libffi-3.2.1/include" LIBFFI_LIBS="-L${MEEP_PATH}/lib -lffi" BDW_GC_CFLAGS="${MY_CPPFLAGS}" BDW_GC_LIBS="-L${MEEP_PATH}/lib -lgc" 
make -j8
make install

# harminv
cd $BUILD_PATH
tar xf $DOWN_PATH/harminv-1.4.1.tar.gz
cd ./harminv-1.4.1
./configure LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}" --prefix=${MEEP_PATH} --enable-shared --enable-static
make -j4
make install

#libctl
cd $BUILD_PATH
tar xf $DOWN_PATH/libctl-$LIBCTL_VER.tar.gz
cd ./libctl-$LIBCTL_VER
./configure LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}" --prefix=${MEEP_PATH} --enable-shared --enable-static
make -j4
make install

#h5utils
cd $BUILD_PATH
tar xf $DOWN_PATH/h5utils-1.13.1.tar.gz
cd ./h5utils-1.13.1
./configure CC=mpicc LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}" --prefix=${MEEP_PATH} --enable-static
make -j4
make install

#mpb
cd $BUILD_PATH
tar xf $DOWN_PATH/mpb-$MPB_VER.tar.gz
cd ./mpb-$MPB_VER
./configure CC=mpicc LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}" --with-libctl=${MEEP_PATH}/share/libctl --prefix=${MEEP_PATH} --with-hermitian-eps --enable-shared --enable-static
make -j4
make install

#libGDSII
#cd $BUILD_PATH
#cp $DOWN_PATH/libGDSII-master-yi.tar.gz .
#tar xf $DOWN_PATH/libGDSII-master-yi.tar.gz
#cd ./libGDSII-master
#./configure --prefix=${MEEP_PATH}
#make -j2
#make install
#cd $BUILD_PATH

#meep
cd $BUILD_PATH
tar xf $DOWN_PATH/meep-$MEEP_VER.tar.gz
cd ./meep-$MEEP_VER
./configure CC=mpicc CXX=mpic++ LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}" --with-libctl=${MEEP_PATH}/share/libctl --prefix=${MEEP_PATH} --with-mpi --without-python --enable-static
make -j4
make install
cd $BUILD_PATH

echo "Build sucessfully"
END_TIME=$(date +%s)
echo "time to build: $((END_TIME-START_TIME))s"

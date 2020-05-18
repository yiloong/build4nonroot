#!/bin/bash
set -e

BUILD_PATH=$PWD
DOWN_PATH="${HOME}/Downloads"
OBS_PATH="${HOME}/opt/obs-23.1.0"
RPATH_FLAGS="-Wl,-rpath,${OBS_PATH}/lib"
MY_LDFLAGS="-L${OBS_PATH}/lib ${RPATH_FLAGS}"
MY_CPPFLAGS="-I${OBS_PATH}/include"
export PKG_CONFIG_PATH=${OBS_PATH}/lib/pkgconfig

cd $BUILD_PATH
tar xf $DOWN_PATH/x264-stable.tar.bz2
cd x264-stable
./configure --enable-static --enable-shared --prefix=${OBS_PATH} #--disable-asm
make -j4 && make install

#cd $BUILD_PATH
#tar xf $DOWN_PATH/x265_3.0.tar.gz
#cd x265_3.0/build/linux
#cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=${OBS_PATH} -DCMAKE_INSTALL_RPATH=${OBS_PATH}/lib ../../source
#make -j10 && make install

cd $BUILD_PATH
tar xf $DOWN_PATH/ffmpeg-4.1.3.tar.bz2
cd ffmpeg-4.1.3
./configure --prefix=${OBS_PATH} --pkgconfigdir=${OBS_PATH}/lib/pkgconfig --enable-shared --enable-libx264 --enable-libx265 --enable-gpl --extra-ldflags="${MY_LDFLAGS}" --extra-cflags="${MY_CPPFLAGS}"
make -j10 && make install

cd $BUILD_PATH
tar xf $DOWN_PATH/obs-studio-23.1.0.tar.gz
mkdir obs-studio-23.1.0/build
cd obs-studio-23.1.0/build
cmake -DUNIX_STRUCTURE=1 -DCMAKE_INSTALL_PREFIX=${OBS_PATH} -DCMAKE_INSTALL_RPATH=${OBS_PATH}/lib ..


#!/bin/bash
# First written on 2019-05-21 by yiloong
# Checked in docker on 2020-04-07 by yiloong
# Updated on 2020-04-13 by yiloong: stable 2.0.0 release
# Updated on 2020-05-17 by yiloong: stable 2.1.0 release
set -e

START_TIME=$(date +%s)
FFMPEG_VER=3.4.7
FREERDP_VER=2.1.0
BUILD_PATH=$PWD
DOWN_PATH="${HOME}/Downloads"
RDP_PATH="/home/yiloong/opt/freerdp-$FREERDP_VER"
RPATH_FLAGS="-Wl,-rpath,${RDP_PATH}/lib"
MY_LDFLAGS="-L${RDP_PATH}/lib ${RPATH_FLAGS}"
MY_CPPFLAGS="-I${RDP_PATH}/include"
export PKG_CONFIG_PATH=${RDP_PATH}/lib/pkgconfig

# apt install nasm libdrm-dev xorg-dev cmake libsystemd-dev libwayland-dev 
#             libxkbcommon-dev libssl-dev libasound2-dev
#             libglib2.0-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
#             libusb-1.0-0-dev libpulse-dev

mkdir -p $DOWN_PATH
cd $DOWN_PATH
wget 172.17.0.1:8000/x264-stable.tar.bz2
wget 172.17.0.1:8000/ffmpeg-${FFMPEG_VER}.tar.gz
wget 172.17.0.1:8000/libva_2.1.0.orig.tar.bz2
wget 172.17.0.1:8000/libvdpau_1.1.1.orig.tar.bz2
wget 172.17.0.1:8000/freerdp-${FREERDP_VER}.tar.gz

cd $BUILD_PATH
tar xf $DOWN_PATH/x264-stable.tar.bz2
cd x264-stable
./configure --enable-shared --prefix=${RDP_PATH}
make -j4 && make install

# ffmpeg
cd $BUILD_PATH
tar xf $DOWN_PATH/ffmpeg-${FFMPEG_VER}.tar.gz
cd ffmpeg-${FFMPEG_VER}
./configure --prefix=${RDP_PATH} --pkgconfigdir=${RDP_PATH}/lib/pkgconfig --enable-avresample --enable-shared --disable-static --enable-libx264 --enable-gpl --extra-ldflags="${MY_LDFLAGS}" --extra-cflags="${MY_CPPFLAGS}"
make -j4 && make install

cd $BUILD_PATH
tar xf $DOWN_PATH/libva_2.1.0.orig.tar.bz2
cd libva-2.1.0
./configure --prefix=${RDP_PATH} PKG_CONFIG_PATH=${RDP_PATH}/lib/pkgconfig LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}"
make -j1 && make install

cd $BUILD_PATH
tar xf $DOWN_PATH/libvdpau_1.1.1.orig.tar.bz2
cd libvdpau-1.1.1
./configure --prefix=${RDP_PATH} PKG_CONFIG_PATH=${RDP_PATH}/lib/pkgconfig LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}"
make -j1 && make install

cd $BUILD_PATH
tar xf $DOWN_PATH/freerdp-${FREERDP_VER}.tar.gz
mkdir freerdp-${FREERDP_VER}/build
cd freerdp-${FREERDP_VER}/build
cmake -DCMAKE_INSTALL_PREFIX=${RDP_PATH} -DCMAKE_INSTALL_RPATH=${RDP_PATH}/lib -DWITH_CUPS=OFF -DWITH_PCSC=OFF -DWITH_SWSCALE=ON ..
make -j4 && make install

echo "Build sucessfully"
END_TIME=$(date +%s)
echo "time to build: $((END_TIME-START_TIME))s"

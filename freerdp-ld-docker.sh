#!/bin/bash
# First written on 2020-05-28 by yiloong

set -e

START_TIME=$(date +%s)

FREERDP_VER=2.1.2
BUILD_PATH=$PWD
DOWN_PATH="${HOME}/Downloads"
RDP_PATH="/home/yiloong/opt/freerdp-$FREERDP_VER"
RPATH_FLAGS="-Wl,-rpath,${RDP_PATH}/lib"
MY_LDFLAGS="-L${RDP_PATH}/lib ${RPATH_FLAGS}"
MY_CPPFLAGS="-I${RDP_PATH}/include"
export PKG_CONFIG_PATH=${RDP_PATH}/lib/pkgconfig

apt install nasm libdrm-dev xorg-dev cmake libsystemd-dev libwayland-dev libxkbcommon-dev libssl-dev libasound2-dev libglib2.0-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libusb-1.0-0-dev libpulse-dev wget libswscale-dev libavresample-dev
apt build-dep freerdp2-x11

mkdir -p $DOWN_PATH
cd $DOWN_PATH
wget 172.17.0.1:8000/freerdp-${FREERDP_VER}.tar.gz

cd $BUILD_PATH
tar xf $DOWN_PATH/freerdp-${FREERDP_VER}.tar.gz
mkdir freerdp-${FREERDP_VER}/build
cd freerdp-${FREERDP_VER}/build
cmake -DCMAKE_INSTALL_PREFIX=${RDP_PATH} -DCMAKE_INSTALL_RPATH=${RDP_PATH}/lib -DWITH_CUPS=OFF -DWITH_PCSC=OFF -DWITH_SWSCALE=ON ..
make -j4 && make install

echo "Build sucessfully"
echo "Copying libs..."
mkdir -p /home/yiloong/opt/lib/freerdp
cp /usr/lib/x86_64-linux-gnu/{libswscale.so.4,libavcodec.so.57,libavutil.so.55,libswresample.so.2,libcrystalhd.so.3,libva.so.2,libzvbi.so.0,libxvidcore.so.4,libx265.so.146,libx264.so.152,libwebpmux.so.3,libsnappy.so.1,libshine.so.3,libopenjp2.so.7,libgsm.so.1,libvdpau.so.1,libva-x11.so.2,libva-drm.so.2,libsoxr.so.0} /home/yiloong/opt/lib/freerdp/
echo "Done."
END_TIME=$(date +%s)
echo "time to build: $((END_TIME-START_TIME))s"

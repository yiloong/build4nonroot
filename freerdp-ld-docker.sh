#!/bin/bash
# First written on 2020-05-28 by yiloong

set -e

START_TIME=$(date +%s)

FREERDP_VER=2.6.1
RDP_PATH="/home/yiloong/opt/freerdp-$FREERDP_VER"

apt install ninja-build build-essential debhelper cdbs dpkg-dev autotools-dev cmake pkg-config xmlto libssl-dev docbook-xsl xsltproc libxkbfile-dev libx11-dev libwayland-dev libxrandr-dev libxi-dev libxrender-dev libxext-dev libxinerama-dev libxfixes-dev libxcursor-dev libxv-dev libxdamage-dev libxtst-dev libcups2-dev libpcsclite-dev libasound2-dev libpulse-dev libjpeg-dev libgsm1-dev libusb-1.0-0-dev libudev-dev libdbus-glib-1-dev uuid-dev libxml2-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libfaad-dev libfaac-dev libavresample-dev libswscale-dev
apt build-dep freerdp2-x11

cd ~
wget 172.17.0.1/freerdp-${FREERDP_VER}.tar.gz
tar xf freerdp-${FREERDP_VER}.tar.gz
mkdir build
cmake -GNinja -DWITH_CAIRO=ON -DWITH_SWSCALE=ON -DCHANNEL_URBDRC=ON -DWITH_DSP_FFMPEG=ON -DWITH_CUPS=ON -DWITH_PULSE=ON -DWITH_FAAC=ON -DWITH_FAAD2=ON -DWITH_GSM=ON -Bbuild -Hfreerdp-2.6.1 -DCMAKE_INSTALL_PREFIX=${RDP_PATH} -DCMAKE_INSTALL_RPATH=${RDP_PATH}/lib
cmake --build build -j4
cmake --build build --target package

echo "Build sucessfully"
echo "Copying libs..."
mkdir -p /home/yiloong/opt/lib/freerdp
cp /usr/lib/x86_64-linux-gnu/{libzvbi.so.0,libaom.so.0,libcodec2.so.0.9,libgsm.so.1,libshine.so.3,libx264.so.155,libx265.so.179,libxvidcore.so.4,libva.so.2,libva-drm.so.2,libva-x11.so.2,libOpenCL.so.1,libvdpau.so.1,libswscale.so.5,libavcodec.so.58,libavutil.so.56,libswresample.so.3} /home/yiloong/opt/lib/freerdp/
echo "Done."
END_TIME=$(date +%s)
echo "time to build: $((END_TIME-START_TIME))s"

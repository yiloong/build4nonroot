#!/bin/bash
# Ubuntu 20.04 client need to install qt5-gtk-platformtheme
# Updated on 2020-05-11 for vlc-3.0.10
# Updated on 2020-07-16 for vlc-3.0.11
# Updated on 2020-08-07 for Ubuntu 20.04

set -e
apt install -y bash-completion build-essential wget cmake unzip libgstreamer-plugins-base1.0-dev nasm ninja-build libpcsclite-dev libglib2.0-dev cmake-curses-gui pigz python3-setuptools bash-completion libtasn1-6-dev aom-tools libebml-dev
apt-get build-dep -y vlc

START_TIME=$(date +%s)
BUILD_PATH=$PWD

cd $BUILD_PATH
# https://github.com/mesonbuild/meson/releases
wget 172.17.0.1:8000/docker/meson-0.59.3.tar.gz
tar xf meson-0.59.3.tar.gz
cd meson-0.59.3
python3 setup.py install

cd $BUILD_PATH
# https://github.com/videolabs/libdsm/releases
wget 172.17.0.1:8000/docker/libdsm-0.3.2.tar.gz
tar xf libdsm-0.3.2.tar.gz
cd libdsm-0.3.2
./configure
make -j2
make install

cd $BUILD_PATH
# https://code.videolan.org/videolan/dav1d
wget 172.17.0.1:8000/docker/dav1d-0.9.2.tar.bz2
tar xf dav1d-0.9.2.tar.bz2
cd dav1d-0.9.2
meson builddir && cd builddir
ninja
ninja install

cd $BUILD_PATH
wget 172.17.0.1:8000/docker/schroedinger-1.0.11.tar.gz
tar xf schroedinger-1.0.11.tar.gz
cd schroedinger-1.0.11
./configure
make -j4
make install

cd $BUILD_PATH
# https://github.com/divideconcept/FluidLite
wget 172.17.0.1:8000/docker/fluidlite.zip
unzip -q fluidlite.zip
cd FluidLite-master/
mkdir build
cd build/
cmake ..
make
make install

cd $BUILD_PATH
wget 172.17.0.1:8000/docker/aribb25-0.2.7.tar.bz2
tar xf aribb25-0.2.7.tar.bz2
cd aribb25-0.2.7
./bootstrap
#apt install libpcsclite-dev
./configure
make
make install

cd $BUILD_PATH
# https://github.com/Haivision/srt/releases Library srt >= 1.2.2 srt < 1.3.0 needed
wget 172.17.0.1:8000/docker/srt-1.2.3.tar.gz
tar xf srt-1.2.3.tar.gz
cd srt-1.2.3/
# ?? ./configure
#  -bash: ./configure: /usr/bin/tclsh: bad interpreter: No such file or directory
mkdir build
cd build/
cmake ..
make -j4
make install

cd $BUILD_PATH
wget 172.17.0.1:8000/docker/goom-2k4-0-src.tar.gz
tar xf goom-2k4-0-src.tar.gz
cd goom2k4-0/
./configure
make
make install

## Failed with glib 1.2/1.3 building failure
# wget 172.17.0.1:8000/docker/xmms-1.2.11.tar.bz2
# tar xf xmms-1.2.11.tar.bz2
# cd xmms-1.2.11
# ./configure

cd $BUILD_PATH
# https://sourceforge.net/projects/modplug-xmms/files/libmodplug/
wget 172.17.0.1:8000/docker/libmodplug-0.8.9.0.tar.gz
tar xf libmodplug-0.8.9.0.tar.gz
cd libmodplug-0.8.9.0
./configure
make -j2
make install

cd $BUILD_PATH
# https://www.videolan.org/vlc/download-sources.html
wget 172.17.0.1:8000/vlc-3.0.16.tar.xz
tar xf vlc-3.0.16.tar.xz
cd vlc-3.0.16
## see https://github.com/Haivision/srt/issues/1210#issuecomment-707032114
#sed -i 's/SRTO_TSBPDDELAY/SRTO_LATENCY/g' modules/access/srt.c
#sed -i 's/SRTO_TSBPDDELAY/SRTO_LATENCY/g' modules/access_output/srt.c
./configure --prefix=/home/yiloong/opt/vlc-3.0.16
make -j4
make install

# Then need to copy libs
cd $BUILD_PATH
mkdir ubuntu && cd ubuntu
cp /usr/lib/x86_64-linux-gnu/libbluray.so.2 .
cp /usr/lib/x86_64-linux-gnu/liba52-0.7.4.so .
cp /usr/lib/x86_64-linux-gnu/libaribb24.so.0 .
cp /usr/lib/x86_64-linux-gnu/libavcodec.so.58 .
cp /usr/lib/x86_64-linux-gnu/libavutil.so.56 .
cp /usr/lib/x86_64-linux-gnu/libBasicUsageEnvironment.so.1 .
cp /usr/lib/x86_64-linux-gnu/libcddb.so.2 .
cp /usr/lib/x86_64-linux-gnu/libdca.so.0 .
cp /usr/lib/x86_64-linux-gnu/libdouble-conversion.so.3 .
cp /usr/lib/x86_64-linux-gnu/libdvbpsi.so.10 .
cp /usr/lib/x86_64-linux-gnu/libdvdnav.so.4 .
cp /usr/lib/x86_64-linux-gnu/libfaad_drm.so.2 .
cp /usr/lib/x86_64-linux-gnu/libfaad.so.2 .
cp /usr/lib/x86_64-linux-gnu/libgroupsock.so.8 .
cp /usr/lib/x86_64-linux-gnu/libgsm.so.1 .
cp /usr/lib/x86_64-linux-gnu/libixml.so.10 .
cp /usr/lib/x86_64-linux-gnu/libkate.so.1 .
cp /usr/lib/x86_64-linux-gnu/libliveMedia.so.77 .
cp /usr/lib/x86_64-linux-gnu/liblua5.2.so.0 .
cp /usr/lib/x86_64-linux-gnu/libmad.so.0 .
cp /usr/lib/x86_64-linux-gnu/libmatroska.so.6 .
cp /usr/lib/x86_64-linux-gnu/libmpcdec.so.6 .
cp /usr/lib/x86_64-linux-gnu/libmpeg2.so.0 .
cp /usr/lib/x86_64-linux-gnu/libnfs.so.13 .
cp /usr/lib/x86_64-linux-gnu/libopenjp2.so.7 .
cp /usr/lib/x86_64-linux-gnu/libplacebo.so.7 .
cp /usr/lib/x86_64-linux-gnu/libprotobuf-lite.so.17 .
cp /usr/lib/x86_64-linux-gnu/libQt5X11Extras.so.5 .
cp /usr/lib/x86_64-linux-gnu/libQt5Xml.so.5 .
cp /usr/lib/x86_64-linux-gnu/libSDL-1.2.so.0 .
cp /usr/lib/x86_64-linux-gnu/libSDL_image-1.2.so.0 .
cp /usr/lib/x86_64-linux-gnu/libshine.so.3 .
cp /usr/lib/x86_64-linux-gnu/libsnappy.so.1 .
cp /usr/lib/x86_64-linux-gnu/libsoxr.so.0 .
cp /usr/lib/x86_64-linux-gnu/libswresample.so.3 .
cp /usr/lib/x86_64-linux-gnu/libswscale.so.5 .
cp /usr/lib/x86_64-linux-gnu/libupnp.so.13 .
cp /usr/lib/x86_64-linux-gnu/libUsageEnvironment.so.3 .
cp /usr/lib/x86_64-linux-gnu/libvdpau.so.1 .
cp /usr/lib/x86_64-linux-gnu/libvulkan.so.1 .
cp /usr/lib/x86_64-linux-gnu/libx264.so.155 .
cp /usr/lib/x86_64-linux-gnu/libx265.so.179 .
cp /usr/lib/x86_64-linux-gnu/libxvidcore.so.4 .
cp /usr/lib/x86_64-linux-gnu/libzvbi.so.0 .
cp /usr/lib/x86_64-linux-gnu/libdvdread.so.7 .
cp /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5 .
cp /usr/lib/x86_64-linux-gnu/libQt5Core.so.5 .
cp /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5 .
cp /usr/lib/x86_64-linux-gnu/libQt5Svg.so.5 .
cp /usr/lib/x86_64-linux-gnu/libpcre2-16.so.0 .
cp /usr/lib/x86_64-linux-gnu/libavformat.so.58 .
cp /usr/lib/x86_64-linux-gnu/libOpenCL.so.1 .
cp /usr/lib/x86_64-linux-gnu/libdc1394.so.22 .
cp /usr/lib/x86_64-linux-gnu/libssh2.so.1 .
cp /usr/lib/x86_64-linux-gnu/libvncclient.so.1 .
cp /usr/lib/x86_64-linux-gnu/libxcb-composite.so.0 .
cp /usr/lib/x86_64-linux-gnu/libspatialaudio.so.0 .
cp /usr/lib/x86_64-linux-gnu/libsndio.so.7.0 .
cp /usr/lib/x86_64-linux-gnu/libaom.so.0 .
cp /usr/lib/x86_64-linux-gnu/libcodec2.so.0.9 .
cp /usr/lib/x86_64-linux-gnu/libass.so.9 .
cp /usr/lib/libsidplay2.so.1 .
cp /usr/lib/libresid-builder.so.0 .
cp /usr/lib/x86_64-linux-gnu/libchromaprint.so.1 .
cp /usr/lib/x86_64-linux-gnu/libpostproc.so.55 .
cp /usr/lib/x86_64-linux-gnu/libgme.so.0 .
cp /usr/lib/x86_64-linux-gnu/libopenmpt.so.0 .
cp /usr/lib/x86_64-linux-gnu/libssh-gcrypt.so.4 .
cp /usr/lib/x86_64-linux-gnu/libmysofa.so.1 .
cp /usr/lib/x86_64-linux-gnu/libebml.so.4 .

cd $BUILD_PATH
mkdir own && cd own
cp -d /usr/local/lib/lib* .
cp -d /usr/local/lib/x86_64-linux-gnu/lib* .

echo "Build sucessfully"
END_TIME=$(date +%s)
echo "time to build: $((END_TIME-START_TIME))s"
exit 0

## END


# for Ubuntu 18.04
cd $BUILD_PATH
mkdir ubuntu && cd ubuntu
cp /usr/lib/x86_64-linux-gnu/libbluray.so.2 .
cp /usr/lib/x86_64-linux-gnu/liba52-0.7.4.so .
cp /usr/lib/x86_64-linux-gnu/libaribb24.so.0 .
cp /usr/lib/x86_64-linux-gnu/libavcodec.so.57 .
cp /usr/lib/x86_64-linux-gnu/libavutil.so.55 .
cp /usr/lib/x86_64-linux-gnu/libBasicUsageEnvironment.so.1 .
cp /usr/lib/x86_64-linux-gnu/libcddb.so.2 .
cp /usr/lib/x86_64-linux-gnu/libdca.so.0 .
cp /usr/lib/x86_64-linux-gnu/libdouble-conversion.so.1 .
cp /usr/lib/x86_64-linux-gnu/libdvbpsi.so.10 .
cp /usr/lib/x86_64-linux-gnu/libdvdnav.so.4 .
cp /usr/lib/x86_64-linux-gnu/libfaad_drm.so.2 .
cp /usr/lib/x86_64-linux-gnu/libfaad.so.2 .
cp /usr/lib/x86_64-linux-gnu/libgroupsock.so.8 .
cp /usr/lib/x86_64-linux-gnu/libgsm.so.1 .
cp /usr/lib/x86_64-linux-gnu/libixml.so.2 .
cp /usr/lib/x86_64-linux-gnu/libkate.so.1 .
cp /usr/lib/x86_64-linux-gnu/libliveMedia.so.62 .
cp /usr/lib/x86_64-linux-gnu/liblua5.2.so.0 .
cp /usr/lib/x86_64-linux-gnu/libmad.so.0 .
cp /usr/lib/x86_64-linux-gnu/libmatroska.so.6 .
cp /usr/lib/x86_64-linux-gnu/libmpcdec.so.6 .
cp /usr/lib/x86_64-linux-gnu/libmpeg2.so.0 .
cp /usr/lib/x86_64-linux-gnu/libnfs.so.11 .
cp /usr/lib/x86_64-linux-gnu/libopenjp2.so.7 .
cp /usr/lib/x86_64-linux-gnu/libplacebo.so.4 .
cp /usr/lib/x86_64-linux-gnu/libprotobuf-lite.so.10 .
cp /usr/lib/x86_64-linux-gnu/libQt5X11Extras.so.5 .
cp /usr/lib/x86_64-linux-gnu/libQt5Xml.so.5 .
cp /usr/lib/x86_64-linux-gnu/libSDL-1.2.so.0 .
cp /usr/lib/x86_64-linux-gnu/libSDL_image-1.2.so.0 .
cp /usr/lib/x86_64-linux-gnu/libshine.so.3 .
cp /usr/lib/x86_64-linux-gnu/libsnappy.so.1 .
cp /usr/lib/x86_64-linux-gnu/libsoxr.so.0 .
cp /usr/lib/x86_64-linux-gnu/libswresample.so.2 .
cp /usr/lib/x86_64-linux-gnu/libswscale.so.4 .
cp /usr/lib/x86_64-linux-gnu/libupnp.so.6 .
cp /usr/lib/x86_64-linux-gnu/libUsageEnvironment.so.3 .
cp /usr/lib/x86_64-linux-gnu/libvdpau.so.1 .
cp /usr/lib/x86_64-linux-gnu/libvulkan.so.1 .
cp /usr/lib/x86_64-linux-gnu/libx264.so.152 .
cp /usr/lib/x86_64-linux-gnu/libx265.so.146 .
cp /usr/lib/x86_64-linux-gnu/libxvidcore.so.4 .
cp /usr/lib/x86_64-linux-gnu/libzvbi.so.0 .
cp /usr/lib/x86_64-linux-gnu/libdvdread.so.4 .
cp /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5 .
cp /usr/lib/x86_64-linux-gnu/libQt5Core.so.5 .
cp /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5 .
cp /usr/lib/x86_64-linux-gnu/libQt5Svg.so.5 .
cp /usr/lib/x86_64-linux-gnu/libpcre16.so.3 .
cp /usr/lib/x86_64-linux-gnu/libcrystalhd.so.3 .
cp /usr/lib/x86_64-linux-gnu/libass.so.9 .
cp /usr/lib/x86_64-linux-gnu/libssh-gcrypt.so.4 .
cp /usr/lib/x86_64-linux-gnu/libssh-gcrypt_threads.so.4 .
cp /usr/lib/x86_64-linux-gnu/libavformat.so.57 .
cp /usr/lib/x86_64-linux-gnu/libpostproc.so.54 .
cp /usr/lib/x86_64-linux-gnu/libvncclient.so.1 .
cp /usr/lib/x86_64-linux-gnu/libxcb-composite.so.0 .
cp /usr/lib/x86_64-linux-gnu/libwebpmux.so.3 .
cp /usr/lib/x86_64-linux-gnu/libchromaprint.so.1 .
cp /usr/lib/x86_64-linux-gnu/libopenmpt.so.0 .
cp /usr/lib/x86_64-linux-gnu/libgme.so.0 .
# cp /usr/lib/x86_64-linux-gnu/libhardsid-builder.so.0 .
# cp /usr/lib/x86_64-linux-gnu/libresid-builder.so.0 .
# cp /usr/lib/x86_64-linux-gnu/libsidplay2.so.1 .
cp /usr/lib/x86_64-linux-gnu/libssh2.so.1 .
cp /usr/lib/x86_64-linux-gnu/libdc1394.so.22 .
cp /usr/lib/x86_64-linux-gnu/libsndio.so.6.1 .
cp /usr/lib/x86_64-linux-gnu/libthreadutil.so.6 .
cp /usr/lib/libsidplay2.so.1 .
cp /usr/lib/libresid-builder.so.0 .

# libva.txt
apt-get build-dep libva
wget 172.17.0.1:8000/libva_2.7.0.orig.tar.gz
./configure --disable-static --prefix=/home/yiloong/opt/libva2


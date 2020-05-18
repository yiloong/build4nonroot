#!/bin/bash
set -e
# changes in 2.2: remove static

START_TIME=$(date +%s)
BUILD_PATH=$PWD
DOWN_PATH="${HOME}/Downloads"
VLC_PATH="${HOME}/opt/vlc-3.0.6"
RPATH_FLAGS="-Wl,-rpath,${VLC_PATH}/lib"
MY_LDFLAGS="-L${VLC_PATH}/lib ${RPATH_FLAGS}"
MY_CPPFLAGS="-I${VLC_PATH}/include"
export PKG_CONFIG_PATH=${VLC_PATH}/lib/pkgconfig

cd $BUILD_PATH
tar xf $DOWN_PATH/faac-1.29.9.2.tar.gz
cd faac-1.29.9.2
./configure --prefix=${VLC_PATH} PKG_CONFIG_PATH=${VLC_PATH}/lib/pkgconfig
make -j4 && make install

mkdir -p $VLC_PATH
cd $VLC_PATH
tar xf $DOWN_PATH/dav1d-0.2.1-build.tar.gz
#meson build --buildtype release
#ninja -C build
#DESTDIR=${VLC_PATH} ninja install -C build

cd $BUILD_PATH
tar xf $DOWN_PATH/libtiger-0.3.4.tar.gz
cd libtiger-0.3.4
./configure --prefix=${VLC_PATH} PKG_CONFIG_PATH=${VLC_PATH}/lib/pkgconfig
make -j4 && make install

cd $BUILD_PATH
tar xf $DOWN_PATH/goom-2k4-0-src.tar.gz
cd goom2k4-0
./configure --prefix=${VLC_PATH} PKG_CONFIG_PATH=${VLC_PATH}/lib/pkgconfig
make -j4 && make install

cd $BUILD_PATH
tar xf $DOWN_PATH/srt-1.2.3.tar.gz
cd srt-1.2.3
./configure --prefix=${VLC_PATH}
make -j4 && make install

cd $BUILD_PATH
tar xf $DOWN_PATH/schroedinger-1.0.11.tar.gz
cd schroedinger-1.0.11
./configure --prefix=${VLC_PATH} PKG_CONFIG_PATH=${VLC_PATH}/lib/pkgconfig
make -j4 && make install

cd $BUILD_PATH
tar xf $DOWN_PATH/libvpx-1.4.0.tar.bz2
cd libvpx-1.4.0
./configure --prefix=${VLC_PATH} --enable-shared 
make -j8 && make install

cd $BUILD_PATH
tar xf $DOWN_PATH/x264-stable.tar.bz2
cd x264-stable
./configure --enable-shared --prefix=${VLC_PATH} #--disable-asm
make -j8 && make install

cd $BUILD_PATH
tar xf $DOWN_PATH/x265_3.0.tar.gz
cd x265_3.0/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=${VLC_PATH} -DCMAKE_INSTALL_RPATH=${OBS_PATH}/lib ../../source
make -j10 && make install

cd $BUILD_PATH
tar xf $DOWN_PATH/ffmpeg-4.1.3.tar.bz2
cd ffmpeg-4.1.3
./configure --prefix=${VLC_PATH} --pkgconfigdir=${VLC_PATH}/lib/pkgconfig --enable-shared --disable-static --enable-libx264 --enable-libx265 --enable-gpl --extra-ldflags="${MY_LDFLAGS}" --extra-cflags="${MY_CPPFLAGS}"
make -j10 && make install

cd $BUILD_PATH
tar xf $DOWN_PATH/libva_2.1.0.orig.tar.bz2
cd libva-2.1.0
./configure --prefix=${VLC_PATH} PKG_CONFIG_PATH=${VLC_PATH}/lib/pkgconfig LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}"
make -j4 && make install

# DVD
cd $BUILD_PATH
tar xf $DOWN_PATH/libdvdcss-1.4.2.tar.bz2
cd libdvdcss-1.4.2
./configure --prefix=${VLC_PATH} PKG_CONFIG_PATH=${VLC_PATH}/lib/pkgconfig
make -j4 && make install

cd $BUILD_PATH
tar xf $DOWN_PATH/libdvdread-6.0.1.tar.bz2
cd libdvdread-6.0.1
./configure --prefix=${VLC_PATH} PKG_CONFIG_PATH=${VLC_PATH}/lib/pkgconfig
make -j4 && make install

cd $BUILD_PATH
tar xf $DOWN_PATH/libdvdnav-6.0.0.tar.bz2
cd libdvdnav-6.0.0
./configure --prefix=${VLC_PATH} PKG_CONFIG_PATH=${VLC_PATH}/lib/pkgconfig
make -j4 && make install

cd $BUILD_PATH
tar xf $DOWN_PATH/vlc-3.0.6.tar.xz
cd vlc-3.0.6
#./configure  '--prefix=/home/yiloong/opt/vlc-3.0.6' 'LDFLAGS=-L/home/yiloong/opt/vlc-3.0.6/lib -Wl,-rpath,/home/yiloong/opt/vlc-3.0.6/lib' 'CPPFLAGS=-I/home/yiloong/opt/vlc-3.0.6/include'
./configure --prefix=${VLC_PATH} PKG_CONFIG_PATH=${VLC_PATH}/lib/pkgconfig LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}"
make -j8 && make install

echo "Build sucessfully"
END_TIME=$(date +%s)
echo "time to build: $((END_TIME-START_TIME))s"

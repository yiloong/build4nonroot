#!/bin/bash
# Auther: yiloong
# Date: 2020-09-10
# Ver: 1.4
# Build shadowsocks-libev statically.
# To build the final proj statically, all its depdpkgs needs built statically too.

SS_VER="3.3.4"
BUILD_PATH=$PWD
DEP_PATH="${BUILD_PATH}/package-built"
SS_PATH="${BUILD_PATH}/out/shadowsocks-libev-${SS_VER}"
cpu=4

wget 172.17.0.1:8000/shadowsocks-libev-${SS_VER}.tar.gz
wget 172.17.0.1:8000/libev-4.33.tar.gz
wget 172.17.0.1:8000/mbedtls-2.7.15-apache.tgz
wget 172.17.0.1:8000/libsodium-1.0.18-stable.tar.gz
wget 172.17.0.1:8000/pcre-8.44.tar.gz
wget 172.17.0.1:8000/c-ares-1.16.1.tar.gz
apt install xmlto asciidoc

tar xf libev-4.33.tar.gz
cd libev-4.33
./configure --prefix=$DEP_PATH --enable-static --disable-shared
make -j$cpu
make install
cd ..

tar xf mbedtls-2.7.15-apache.tgz
cd mbedtls-2.7.15
make -j$cpu DESTDIR=$DEP_PATH LDFLAGS=-static install
cd ..

tar xf libsodium-1.0.18-stable.tar.gz
cd libsodium-stable
./configure --prefix=$DEP_PATH --enable-static --disable-shared
make -j$cpu
make install
cd ..

tar xf pcre-8.44.tar.gz
cd pcre-8.44
./configure --prefix=$DEP_PATH --enable-static --disable-shared --enable-unicode-properties
make -j$cpu
make install
cd ..

tar xf c-ares-1.16.1.tar.gz
cd c-ares-1.16.1
./configure --prefix=$DEP_PATH --enable-static --disable-shared
make -j$cpu
make install
cd ..

tar xf shadowsocks-libev-${SS_VER}.tar.gz
cd shadowsocks-libev-${SS_VER}
./configure CPPFLAGS="-I${DEP_PATH}/include" --prefix=${SS_PATH} --with-mbedtls="${DEP_PATH}" --with-pcre="${DEP_PATH}" --with-sodium="${DEP_PATH}" --with-cares="${DEP_PATH}" --with-ev="${DEP_PATH}"  LIBS="-lm"
make -j$cpu
make install
cd ..
cd out/
tar czf shadowsocks-libev-${SS_VER}-docker.tar.gz shadowsocks-libev-${SS_VER}
echo "SUCCESS"

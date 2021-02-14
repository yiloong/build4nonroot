#!/bin/bash
apt install mingw-w64 automake autoconf libtool
arch=x86_64
host=$arch-w64-mingw32
prefix=$PWD/out/$arch
args="--host=${host} --prefix=${prefix} --disable-shared --enable-static"
cpu=4

# https://c-ares.haxx.se/download/
# http://dist.schmorp.de/libev/
# https://download.libsodium.org/libsodium/releases/libsodium-1.0.18-stable.tar.gz
# https://github.com/ARMmbed/mbedtls/releases
# https://ftp.pcre.org/pub/pcre/

# c-ares-1.17.1 failed
wget 172.17.0.1:8000/c-ares-1.16.1.tar.gz
tar xf c-ares-1.16.1.tar.gz
wget 172.17.0.1:8000/libev-mingw.zip
unzip libev-mingw.zip
wget 172.17.0.1:8000/libsodium-1.0.18-stable.tar.gz
tar xf libsodium-1.0.18-stable.tar.gz
wget 172.17.0.1:8000/mbedtls-2.16.9.tar.gz
tar xf mbedtls-2.16.9.tar.gz
wget 172.17.0.1:8000/pcre-8.44.tar.gz
tar xf pcre-8.44.tar.gz
wget 172.17.0.1:8000/shadowsocks-libev-3.3.5.tar.gz
tar xf shadowsocks-libev-3.3.5.tar.gz

cd libev-mingw
./configure $args
make -j$cpu install
cd ..

cd mbedtls-2.16.9
make -j$cpu lib WINDOWS=1 CC="${host}-gcc" AR="${host}-ar"
DESTDIR="${prefix}"
mkdir -p "${DESTDIR}"/include/mbedtls
cp -r include/mbedtls "${DESTDIR}"/include
mkdir -p "${DESTDIR}"/lib
cp -RP library/libmbedtls.*    "${DESTDIR}"/lib
cp -RP library/libmbedx509.*   "${DESTDIR}"/lib
cp -RP library/libmbedcrypto.* "${DESTDIR}"/lib
unset DESTDIR

cd ../libsodium-stable
./autogen.sh
./configure $args
make -j$cpu install

cd ../pcre-8.44
./configure $args --disable-cpp --enable-unicode-properties
make -j$cpu install

cd ../c-ares-1.16.1
./configure $args
make -j$cpu install
cd ..

prefix=$PWD/outss/$arch
dep=$PWD/out/x86_64

cd shadowsocks-libev-3.3.5
./configure --host=${host} --prefix=${prefix} --disable-documentation --with-ev="$dep" --with-mbedtls="$dep" --with-sodium="$dep" --with-pcre="$dep" --with-cares="$dep" CFLAGS="-DCARES_STATICLIB -DPCRE_STATIC"
make -j$cpu LDFLAGS="-all-static -L${dep}/lib"
make install
echo "SUCCESS"

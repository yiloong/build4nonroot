#!/bin/bash
apt install mingw-w64 automake autoconf libtool
arch=x86_64
host=$arch-w64-mingw32
prefix=$PWD/out/$arch
args="--host=${host} --prefix=${prefix} --disable-shared --enable-static"
cpu=4

tar xf c-ares-1.15.0.tar.gz
tar xf libev-4.31.tar.gz
tar xf libsodium-1.0.18.tar.gz
tar xf mbedtls-2.7.14-apache.tgz
tar xf pcre-8.44.tar.gz
tar xf shadowsocks-libev-3.3.4.tar.gz

cd libev-4.31
./configure $args
make -j$cpu install
cd ..

cd mbedtls-2.7.14
make -j$cpu lib WINDOWS=1 CC="${host}-gcc" AR="${host}-ar"
DESTDIR="${prefix}"
mkdir -p "${DESTDIR}"/include/mbedtls
cp -r include/mbedtls "${DESTDIR}"/include
mkdir -p "${DESTDIR}"/lib
cp -RP library/libmbedtls.*    "${DESTDIR}"/lib
cp -RP library/libmbedx509.*   "${DESTDIR}"/lib
cp -RP library/libmbedcrypto.* "${DESTDIR}"/lib
unset DESTDIR

cd ../libsodium-1.0.18
./autogen.sh
./configure $args
make -j$cpu install

cd ../pcre-8.44
./configure $args --disable-cpp --enable-unicode-properties
make -j$cpu install

cd ../c-ares-1.15.0
./configure $args
make -j$cpu install
cd ..

prefix=$PWD/outss/$arch
dep=$PWD/out/x86_64

cd shadowsocks-libev-3.3.4
./configure --host=${host} --prefix=${prefix} --disable-documentation --with-ev="$dep" --with-mbedtls="$dep" --with-sodium="$dep" --with-pcre="$dep" --with-cares="$dep" CFLAGS="-DCARES_STATICLIB -DPCRE_STATIC"
make -j$cpu LDFLAGS="-all-static -L${dep}/lib"
make install
echo "SUCCESS"

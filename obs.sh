#!/bin/bash
set -e

BUILD_PATH=$PWD
OBS_PATH="/home/yiloong/opt/obs"
OBS_VER="27.1.3"
RPATH_FLAGS="-Wl,-rpath,${OBS_PATH}/lib"

apt build-dep obs-studio
apt install wget checkinstall

cd $BUILD_PATH
wget 172.17.0.1/obs-studio-${OBS_VER}.tar.gz
tar xf $DOWN_PATH/obs-studio-${OBS_VER}.tar.gz
mkdir obs-studio-${OBS_VER}/build
cd obs-studio-${OBS_VER}/build
cmake -DUNIX_STRUCTURE=1 -DENABLE_PIPEWIRE=OFF -DCMAKE_INSTALL_PREFIX=${OBS_PATH} -DCMAKE_INSTALL_RPATH=${OBS_PATH}/lib -DBUILD_BROWSER=OFF ..
make -j8
checkinstall --default --pkgname=obs-studio --fstrans=no --backup=no --pkgversion="${OBS_VER}" --deldoc=yes


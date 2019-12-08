#! /bin/bash
# this package require libressl and libnl
set -e
. ../env.sh
. ../toolchain.sh
dir="wpa_supplicant-2.7"
cd ${ANTIX_BASE}/source
if [ ! -f "${dir}.tar.gz" ]; then
    # download it
    wget https://w1.fi/releases/${dir}.tar.gz
fi
tar xvf ${dir}.tar.gz
cd ${dir}/wpa_supplicant

cp defconfig .config
make -j 8
#make CC=arm-linux-gnueabi-gcc
make install DESTDIR=${ANTIX_PKG_BUILD}



cp -avrf ${ANTIX_PKG_BUILD}/usr/local/sbin/wpa_* ${ANTIX_ROOT}/usr/bin

cd ${ANTIX_BASE}/source
rm -rf  ${dir}
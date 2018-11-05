#! /bin/bash
set -e
. ../env.sh
cd ${ANTIX_BASE}/source
if [ ! -f "v4l-utils-1.16.1.tar.bz2" ]; then
    # download it
    wget https://linuxtv.org/downloads/v4l-utils/v4l-utils-1.16.1.tar.bz2
fi
tar xvf v4l-utils-1.16.1.tar.bz2
cd v4l-utils-1.16.1
./configure --host=${ANTIX_TARGET} 
make DESTDIR=${ANTIX_PKG_BUILD}/libv4l install
#cp -rf ${ANTIX_PKG_BUILD}/libjpeg/usr/local/* ${ANTIX_TOOLS}/${ANTIX_TARGET}/
# install shared library to the toolchain
cd ${ANTIX_BASE}/source
rm -rf v4l-utils-1.16.1 #${ANTIX_PKG_BUILD}/libjpeg

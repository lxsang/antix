#! /bin/bash
set -e
. ../env.sh
cd ${ANTIX_BASE}/source
if [ ! -d "libv4l" ]; then
    # download it
    git clone https://github.com/philips/libv4l
fi
cd libv4l
CC=${ANTIX_TARGET}-gcc make -j 8
make DESTDIR=${ANTIX_PKG_BUILD}/libv4l install
#cp -rf ${ANTIX_PKG_BUILD}/libjpeg/usr/local/* ${ANTIX_TOOLS}/${ANTIX_TARGET}/
# install shared library to the toolchain
cd ${ANTIX_BASE}/source
rm -rf libv4l #${ANTIX_PKG_BUILD}/libjpeg

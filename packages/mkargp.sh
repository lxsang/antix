
#! /bin/bash
set -e
. ../env.sh
cd ${ANTIX_BASE}/source
if [ ! -d "argp-standalone" ]; then
    # download it
    git clone https://github.com/jahrome/argp-standalone
fi

cd argp-standalone
./configure --host=${ANTIX_TARGET} CC=${ANTIX_TARGET}-gcc
CC=${ANTIX_TARGET}-gcc make -j 8
CC=${ANTIX_TARGET}-gcc make DESTDIR=${ANTIX_PKG_BUILD}/argp install
#cp -rf ${ANTIX_PKG_BUILD}/libjpeg/usr/local/* ${ANTIX_TOOLS}/${ANTIX_TARGET}/
# install shared library to the toolchain
cd ${ANTIX_BASE}/source
#${ANTIX_PKG_BUILD}/libjpeg

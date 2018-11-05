#! /bin/bash
set -e
. ../env.sh
cd ${ANTIX_BASE}/source
if [ ! -d "argp-standalone" ]; then
    # download it
    git clone https://github.com/jahrome/argp-standalone
fi

cd argp-standalone
./configure --host=${ANTIX_TARGET} CC=${ANTIX_TARGET}-gcc CFLAGS="-march=${ANTIX_ARCH} -mfloat-abi=${ANTIX_FLOAT}"
CC=${ANTIX_TARGET}-gcc CFLAGS="-march=${ANTIX_ARCH} -mfloat-abi=${ANTIX_FLOAT}" make -j 8
CC=${ANTIX_TARGET}-gcc CFLAGS="-march=${ANTIX_ARCH} -mfloat-abi=${ANTIX_FLOAT}" make DESTDIR=${ANTIX_PKG_BUILD}/argp install
cp -rf ${ANTIX_PKG_BUILD}/argp/usr/local/* ${ANTIX_TOOLS}/${ANTIX_TARGET}/
# install shared library to the toolchain
cd ${ANTIX_BASE}/source
rm -rf argp-standalone ${ANTIX_PKG_BUILD}/argp

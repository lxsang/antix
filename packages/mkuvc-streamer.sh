#! /bin/bash
set -e
. ../env.sh
cd ${ANTIX_BASE}/source
if [ ! -d "uvc-streamer" ]; then
    # download it
    git clone https://github.com/bsapundzhiev/uvc-streamer
fi

cd uvc-streamer
CC=${ANTIX_TARGET}-gcc  make -j 8
CC=${ANTIX_TARGET}-gcc make DESTDIR=${ANTIX_PKG_BUILD}/uvc-streamer install
#cp -rf ${ANTIX_PKG_BUILD}/argp/usr/local/* ${ANTIX_TOOLS}/${ANTIX_TARGET}/
# install shared library to the toolchain
cd ${ANTIX_BASE}/source
rm -rf uvc-streamer 
#${ANTIX_PKG_BUILD}/argp

#! /bin/bash
set -e
. ../env.sh
cd ${ANTIX_BASE}/source
if [ ! -f "mjpg-streamer.tar.gz" ]; then
    # download it
    wget http://terzo.acmesystems.it/download/webcam/mjpg-streamer.tar.gz
fi
tar xvf mjpg-streamer.tar.gz
cd mjpg-streamer
make clean
sed  -i -E "s/CC = gcc/CC=${ANTIX_TARGET}-gcc/" Makefile
sed -i -E "s/#include <syslog.h>/#include <syslog.h>\n#include <pthread.h>/" plugins/input.h
sed -i -E "s/PLUGINS \+= input_gspcav1.so/# PLUGINS \+= input_gspcav1.so/" Makefile
sed  -i -E "s%DESTDIR = /usr/local%DESTDIR =${ANTIX_PKG_BUILD}/mjpg-stream%" Makefile
for file in plugins/*; do
    if [ -d "$file" ]; then
        if [ -f "$file/Makefile" ]; then
            echo $file
            sed  -i -E "s/CC = gcc/CC=${ANTIX_TARGET}-gcc/" "$file/Makefile"
        fi
    fi
done
mkdir -p ${ANTIX_PKG_BUILD}/mjpg-stream/{bin,lib}
set +e
ln -s ${ANTIX_TOOLS}/${ANTIX_TARGET}/include/linux/videodev2.h ${ANTIX_TOOLS}/${ANTIX_TARGET}/include/linux/videodev.h
set -e
make -j 8
make  install
#cp -rf ${ANTIX_PKG_BUILD}/libv4l/usr/local/* ${ANTIX_TOOLS}/${ANTIX_TARGET}/
# install shared library to the toolchain
cd ${ANTIX_BASE}/source
rm -rf mjpg-streamer #${ANTIX_PKG_BUILD}/libv4l

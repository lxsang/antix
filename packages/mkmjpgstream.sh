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
sed  -i -E "s%DESTDIR = /usr/local%DESTDIR =${ANTIX_PKG_BUILD}/mjpg-stream%" Makefile
for file in plugins; do
    if [ -d "plugins/$file" ]; then
        if [ -f "plugins/$file/Makefile"]; then
            sed  -i -E "s/CC = gcc/CC=${ANTIX_TARGET}-gcc/" "plugins/$file/Makefile"
        fi
    fi
done
set +e
ln -s ${ANTIX_TOOLS}/${ANTIX_TARGET}/include/linux/videodev2.h ${ANTIX_TOOLS}/${ANTIX_TARGET}/include/linux/videodev.h
set -e
make -j 8
make  install
#cp -rf ${ANTIX_PKG_BUILD}/libv4l/usr/local/* ${ANTIX_TOOLS}/${ANTIX_TARGET}/
# install shared library to the toolchain
cd ${ANTIX_BASE}/source
rm -rf mjpg-streamer #${ANTIX_PKG_BUILD}/libv4l

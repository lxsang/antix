#! /bin/bash
set -e
. ../env.sh
cd ${ANTIX_BASE}/source
if [ ! -f "jpegsrc.v9c.tar.gz" ]; then
    # download it
    wget http://www.ijg.org/files/jpegsrc.v9c.tar.gz
fi
tar xvf jpegsrc.v9c.tar.gz
cd jpeg-9c
./configure --host=${ANTIX_TARGET} \
    --prefix=${ANTIX_TOOLS}/${ANTIX_TARGET}\
   CC=${ANTIX_TARGET}-gcc
make -j 8
make  install
#cp -rf ${ANTIX_PKG_BUILD}/libjpeg/usr/local/* ${ANTIX_TOOLS}/${ANTIX_TARGET}/
cp -av ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libjpeg*.so* ${ANTIX_ROOT}/usr/lib/
# install shared library to the toolchain
cd ${ANTIX_BASE}/source
rm -rf jpeg-9c

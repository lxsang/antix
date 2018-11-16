#! /bin/bash

set -e
. ../env.sh
. ../toolchain.sh
dir="libdrm-2.4.96"
cd ${ANTIX_BASE}/source
if [ ! -f "${dir}.tar.gz" ]; then
    # download it
    wget https://dri.freedesktop.org/libdrm/${dir}.tar.gz
fi
tar xvf ${dir}.tar.gz
cd ${dir}
# configure cross platform
./configure --prefix=${ANTIX_TOOLS}/${ANTIX_TARGET}\
    --build=${ANTIX_HOST}\
    --host=${ANTIX_TARGET}
   
make -j8
make install

cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libdrm.so* ${ANTIX_ROOT}/usr/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libkms.so* ${ANTIX_ROOT}/usr/lib
cd ${ANTIX_BASE}/source
rm -rf  ${dir}
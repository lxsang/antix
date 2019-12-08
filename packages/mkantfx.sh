#! /bin/bash

set -e
. ../env.sh
. ../toolchain.sh
dir="antfx-1.0.0b"
cd ${ANTIX_BASE}/source
if [ ! -f "${dir}.tar.gz" ]; then
    # download it
    wget https://github.com/lxsang/antfx/raw/master/dist/${dir}.tar.gz
fi
tar xvf ${dir}.tar.gz
cd ${dir}

# configure cross platform 
./configure --prefix=${ANTIX_TOOLS}/${ANTIX_TARGET} \
    --build=${ANTIX_HOST}\
    --host=${ANTIX_TARGET} \
    --enable-debug=yes \
    --enable-buffer=yes
   
make -j8
make install

cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libantfx.so* ${ANTIX_ROOT}/usr/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/bin/antfx ${ANTIX_ROOT}/usr/bin
#cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/etc/ ${ANTIX_ROOT}/etc/

cd ${ANTIX_BASE}/source
rm -rf  ${dir}
#! /bin/bash

set -e
. ../env.sh
. ../toolchain.sh
dir="libnl-3.2.25"
cd ${ANTIX_BASE}/source
if [ ! -f "${dir}.tar.gz" ]; then
    # download it
    wget http://www.infradead.org/~tgr/libnl/files/${dir}.tar.gz
fi
tar xvf ${dir}.tar.gz
cd ${dir}

# configure cross platform 
./configure --prefix=${ANTIX_TOOLS}/${ANTIX_TARGET} \
    --build=${ANTIX_HOST}\
    --host=${ANTIX_TARGET}
   
make -j8
make install

cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libnl-3.so* ${ANTIX_ROOT}/usr/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libnl-genl-3.so* ${ANTIX_ROOT}/usr/lib
#cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/etc/ ${ANTIX_ROOT}/etc/

cd ${ANTIX_BASE}/source
rm -rf  ${dir}
#! /bin/bash

set -e
. ../env.sh
. ../toolchain.sh
dir="icu4c-63_1-src"
cd ${ANTIX_BASE}/source
if [ ! -f "${dir}.tgz" ]; then
    # download it
    wget http://download.icu-project.org/files/icu4c/63.1/icu4c-63_1-src.tgz
fi
tar xvf ${dir}.tgz
cd ${dir}
# configure cross platform
./configure --prefix=${ANTIX_PKG_BUILD}/icu\
    --build=${ANTIX_HOST}\
    --host=${ANTIX_TARGET}\
    --disable-samples --disable-tests
   
make -j8
make install

#cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libharfbuzz*.so* ${ANTIX_ROOT}/usr/lib

cd ${ANTIX_BASE}/source
rm -rf  ${dir}

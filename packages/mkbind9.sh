#! /bin/bash

set -e
. ../env.sh
. ../toolchain.sh
dir="bind-9.13.3"
cd ${ANTIX_BASE}/source
if [ ! -f "${dir}.tar.gz" ]; then
    # download it
    wget http://www.mirrorservice.org/sites/ftp.isc.org/isc/bind9/9.13.3/${dir}.tar.gz
fi
tar xvf ${dir}.tar.gz
cd ${dir}
# configure cross platform
./configure --prefix=${ANTIX_PKG_BUILD}/bind9\
    --build=${ANTIX_HOST}\
    --host=${ANTIX_TARGET}\
     --disable-openssl-version-check \
     --enable-shared --disable-static \
     --enable-libbind --disable-atomic \
     --disable-linux-caps \
     --enable-threads 
   
make -j8
make install

#cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libharfbuzz*.so* ${ANTIX_ROOT}/usr/lib

cd ${ANTIX_BASE}/source
rm -rf  ${dir}
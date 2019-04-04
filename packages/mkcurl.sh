#! /bin/bash
# curl support
set -e
. ../env.sh
. ../toolchain.sh
cd ${ANTIX_BASE}/source
if [ ! -f "curl-7.64.1.tar.gz" ]; then
    # download it
    wget https://curl.haxx.se/download/curl-7.64.1.tar.gz
fi
set e+
rm -rf curl-7.64.1
tar xvf curl-7.64.1.tar.gz
cd curl-7.64.1

./configure \
    --prefix=${ANTIX_TOOLS}/${ANTIX_TARGET} \
    --build=${ANTIX_HOST} \
    --host=${ANTIX_TARGET} 
make -j 8
make install
# install it to rootfs
cp -av ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libcurl.so* ${ANTIX_ROOT}/usr/lib/
cp -av ${ANTIX_TOOLS}/${ANTIX_TARGET}/bin/curl ${ANTIX_ROOT}/usr/bin/


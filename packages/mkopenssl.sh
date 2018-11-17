#! /bin/bash
set -e
. ../env.sh
. ../toolchain.sh
cd ${ANTIX_BASE}/source
if [ ! -f "openssl-1.1.1.tar.gz" ]; then
    # download it
    wget https://www.openssl.org/source/openssl-1.1.1.tar.gz
fi
tar xvf openssl-1.1.1.tar.gz
cd openssl-1.1.1
./Configure linux-generic32 shared  -DL_ENDIAN \
    --prefix=${ANTIX_PKG_BUILD}/openssl \
    --openssldir=${ANTIX_ROOT}/usr/local/ssl
make PROCESSOR=ARM
#./Configure linux-generic32 shared no-async -DOPENSSL_NO_ASYNC  -DL_ENDIAN --prefix=${ANTIX_PKG_BUILD}/openssl/usr --openssldir=${ANTIX_ROOT}/usr/local/ssl
#./configure --prefix="${ANTIX_TOOLS}/${ANTIX_TARGET}/usr"  --build=${ANTIX_HOST} --host=${ANTIX_TARGET}
make -j 8 #
#CC=${ANTIX_TARGET}-gcc\
#    RANLIB=${ANTIX_TARGET}-ranlib\
#    LD=${ANTIX_TARGET}-ld\
#    MAKEDEPPROG=${ANTIX_TARGET}-gcc\
#    PROCESSOR=ARM
make install
# install shared library to the toolchain
#cp -v -rf ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/bin/{ocspcheck,openssl} ${ANTIX_ROOT}/usr/bin/
#mkdir -pv ${ANTIX_ROOT}/usr/etc
#cp -v -rf ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/etc/ssl ${ANTIX_ROOT}/usr/etc

#cp -v -rf ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/lib/libcrypto.so* ${ANTIX_ROOT}/usr/lib/
#cp -v -rf ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/lib/libssl.so* ${ANTIX_ROOT}/usr/lib/
#cp -v -rf ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/lib/libtls.so* ${ANTIX_ROOT}/usr/lib/
#cp  -v ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libssp.so* ${ANTIX_ROOT}/usr/lib/
#cd ${ANTIX_BASE}/source
#rm -rf libressl-2.8.1 ${ANTIX_PKG_BUILD}/openssl
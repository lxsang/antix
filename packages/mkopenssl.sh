#! /bin/bash
set -e
. ../env.sh
cd ~/antix/source
if [ ! -f "libressl-2.8.1.tar.gz" ]; then
    # download it
    wget https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.8.1.tar.gz
fi
tar xvf libressl-2.8.1.tar.gz
cd libressl-2.8.1
#./Configure linux-generic32 shared no-async -DOPENSSL_NO_ASYNC  -DL_ENDIAN --prefix=${ANTIX_PKG_BUILD}/openssl/usr --openssldir=${ANTIX_ROOT}/usr/local/ssl
./configure --prefix="/usr"  --build=${ANTIX_HOST} --host=${ANTIX_TARGET}
make -j 8 #
#CC=${ANTIX_TARGET}-gcc\
#    RANLIB=${ANTIX_TARGET}-ranlib\
#    LD=${ANTIX_TARGET}-ld\
#    MAKEDEPPROG=${ANTIX_TARGET}-gcc\
#    PROCESSOR=ARM
make DESTDIR=${ANTIX_PKG_BUILD}/openssl install
# install shared library to the toolchain
cp -v -rf ${ANTIX_PKG_BUILD}/openssl/usr/* ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/
cp -v -rf ${ANTIX_PKG_BUILD}/openssl/usr/bin/* ${ANTIX_ROOT}/usr/bin/
cp -v -rf ${ANTIX_PKG_BUILD}/openssl/usr/etc ${ANTIX_ROOT}/usr/
cp -v -rf ${ANTIX_PKG_BUILD}/openssl/usr/lib/* ${ANTIX_ROOT}/usr/lib/
cp  -v ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libssp* ${ANTIX_ROOT}/usr/lib/
cd ~/antix/source
rm -r libressl-2.8.1 ${ANTIX_PKG_BUILD}/openssl
#! /bin/bash
set -e
. ../env.sh
cd ~/antix/source
if [ ! -f "sqlite-autoconf-3250200.tar.gz" ]; then
    # download it
    wget https://www.sqlite.org/2018/sqlite-autoconf-3250200.tar.gz
fi
tar xvf sqlite-autoconf-3250200.tar.gz
cd sqlite-autoconf-3250200
./configure --host=${ANTIX_TARGET} \
    --prefix=${ANTIX_PKG_BUILD}/sqlite3/usr\
    --without-manpages \
    CC="$ANTIX_TARGET-gcc"
make -j 8
make install
cp -v -rf ${ANTIX_PKG_BUILD}/sqlite3/usr/* ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/
cp -v -rf ${ANTIX_PKG_BUILD}/sqlite3/usr/bin/* ${ANTIX_ROOT}/usr/bin/
cp -v -rf ${ANTIX_PKG_BUILD}/sqlite3/usr/lib/*.so* ${ANTIX_ROOT}/usr/lib/
cd ~/antix/source
rm -rf sqlite-autoconf-3250200 ${ANTIX_PKG_BUILD}/sqlite3
#! /bin/bash
set -e
. ../env.sh
cd ${ANTIX_BASE}/source
if [ ! -f "sqlite-autoconf-3250200.tar.gz" ]; then
    # download it
    wget https://www.sqlite.org/2018/sqlite-autoconf-3250200.tar.gz
fi
tar xvf sqlite-autoconf-3250200.tar.gz
cd sqlite-autoconf-3250200
./configure --host=${ANTIX_TARGET} \
    --prefix=${ANTIX_TOOLS}/${ANTIX_TARGET}\
    --without-manpages \
    CC="$ANTIX_TARGET-gcc"
make -j 8
make install
#cp -v -rf ${ANTIX_PKG_BUILD}/sqlite3/usr/* ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/
cp -v -rf ${ANTIX_TOOLS}/${ANTIX_TARGET}/bin/sqlite3 ${ANTIX_ROOT}/usr/bin/
cp -v -rf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libsqlite*.so* ${ANTIX_ROOT}/usr/lib/
cd ${ANTIX_BASE}/source
rm -rf sqlite-autoconf-3250200
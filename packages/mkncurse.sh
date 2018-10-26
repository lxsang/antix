#! /bin/bash
set -e
. ../env.sh
cd ${ANTIX_BASE}/source
if [ ! -f "ncurses-6.1.tar.gz" ]; then
    # download it
    wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz
fi
tar xvf ncurses-6.1.tar.gz
cd ncurses-6.1
./configure --build=${ANTIX_HOST} --host=${ANTIX_TARGET} \
   --prefix=/usr --libdir=/lib --with-shared \
   --without-debug --without-ada --without-manpages\
   --without-progs --without-cxx-binding --with-build-cc=gcc
make -j 8
make DESTDIR=${ANTIX_PKG_BUILD}/ncurses install
# install shared library to the toolchain
cp -v -rf ${ANTIX_PKG_BUILD}/ncurses/lib/* ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/
cp -v -rf ${ANTIX_PKG_BUILD}/ncurses/usr/* ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/
cp -v -rf ${ANTIX_PKG_BUILD}/ncurses/lib/*.so* ${ANTIX_ROOT}/lib/
cp -v -rf ${ANTIX_PKG_BUILD}/ncurses/usr/bin/* ${ANTIX_ROOT}/usr/bin/
cp -v -rf ${ANTIX_PKG_BUILD}/ncurses/usr/share/* ${ANTIX_ROOT}/usr/share/
cd ${ANTIX_BASE}/source
rm -rf ncurses-6.1 ${ANTIX_PKG_BUILD}/ncurses
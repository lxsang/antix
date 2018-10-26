#! /bin/bash
set -e
. ../env.sh
cd ~/antix-${ANTIX_BOARD}/source
if [ ! -f "readline-7.0.tar.gz" ]; then
    # download it
    wget https://ftp.gnu.org/gnu/readline/readline-7.0.tar.gz
fi
tar xvf readline-7.0.tar.gz
cd readline-7.0 
./configure --build=${ANTIX_HOST} --host=${ANTIX_TARGET} \
    --prefix=/usr --libdir=/lib \
    --without-manpages
make -j 8  SHLIB_XLDFLAGS=-lncurses
make DESTDIR=${ANTIX_PKG_BUILD}/readline install

cp -v -rf ${ANTIX_PKG_BUILD}/readline/lib/* ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/
cp -v -rf ${ANTIX_PKG_BUILD}/readline/usr/* ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/
cp -v -rf ${ANTIX_PKG_BUILD}/readline/lib/*.so* ${ANTIX_ROOT}/lib/
cd ~/antix-${ANTIX_BOARD}/source
rm -rf readline-7.0 ${ANTIX_PKG_BUILD}/readline
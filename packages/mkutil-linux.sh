#! /bin/bash
# build only libblkid and libmount
set -e
. ../env.sh
. ../toolchain.sh
dir="util-linux-2.33"
cd ${ANTIX_BASE}/source
if [ ! -f "${dir}.tar.gz" ]; then
    # download it
    wget https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.33/util-linux-2.33.tar.gz
fi
tar xvf ${dir}.tar.gz
cd ${dir}
# fix ncursew problem
#sed -i -E 's%#include <ncursesw/ncurses_dll.h>%#include <ncurses_dll.h>%' disk-utils/cfdisk.c
# configure cross platform
./configure --prefix=${ANTIX_TOOLS}/${ANTIX_TARGET}\
    --build=${ANTIX_HOST}\
    --host=${ANTIX_TARGET}\
    --without-tinfo\
    --without-python\
    --without-ncursesw\
    --disable-all-programs\
    --enable-libmount\
    --enable-libblkid
   
make -j 10 
make install

cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libblkid.so* ${ANTIX_ROOT}/usr/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libmount.so* ${ANTIX_ROOT}/usr/lib
cd ${ANTIX_BASE}/source
rm -rf  ${dir}
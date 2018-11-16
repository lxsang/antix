#! /bin/bash
set -e
. ../env.sh
. ../toolchain.sh
dir="expat-2.2.6"
cd ${ANTIX_BASE}/source
if [ ! -f "${dir}.tar.bz2" ]; then
    # download it
    wget https://github.com/libexpat/libexpat/releases/download/R_2_2_6/${dir}.tar.bz2
fi
tar xvf ${dir}.tar.bz2
cd ${dir}
# configure cross platform
./configure --prefix=${ANTIX_TOOLS}/${ANTIX_TARGET}\
    --build=${ANTIX_HOST}\
    --host=${ANTIX_TARGET}\
    --without-docbook
   
make -j8
make install

cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libexpat.so* ${ANTIX_ROOT}/usr/lib

cd ${ANTIX_BASE}/source
rm -rf  ${dir}

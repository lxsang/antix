#! /bin/bash
# depend on
# - freetype
# -fontconfig
# -harfbuzz
# -fribidi
set -e
. ../env.sh
. ../toolchain.sh
dir="fribidi-1.0.5"
cd ${ANTIX_BASE}/source
if [ ! -f "${dir}.tar.bz2" ]; then
    # download it
    wget https://github.com/fribidi/fribidi/releases/download/v1.0.5/fribidi-1.0.5.tar.bz2
fi
tar xvf ${dir}.tar.bz2
cd ${dir}
# configure cross platform
./configure --prefix=${ANTIX_TOOLS}/${ANTIX_TARGET}\
    --build=${ANTIX_HOST}\
    --host=${ANTIX_TARGET}
   
make -j8
make install

cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libfribidi.so* ${ANTIX_ROOT}/usr/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/bin/fribidi ${ANTIX_ROOT}/usr/bin
cd ${ANTIX_BASE}/source
rm -rf  ${dir}
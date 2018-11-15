#! /bin/bash
set -e
. ../env.sh
# for example 1.6.35
# or 1.2.59
version=$1
cd ${ANTIX_BASE}/source
dir="libpng-${version}"
if [ ! -f "${dir}.tar.xz" ]; then
    # download it
    wget "https://download.sourceforge.net/libpng/${dir}.tar.xz"
fi
tar xvf ${dir}.tar.xz
cd ${dir}
# configure cross platform
./configure --prefix=${ANTIX_TOOLS}/${ANTIX_TARGET}/\
    --build=${ANTIX_HOST} \
    --host=${ANTIX_TARGET}\
    AR=${ANTIX_TARGET}-ar STRIP=${ANTIX_TARGET}-strip RANLIB=${ANTIX_TARGET}-ranlib
# copy it to the toolchain
make -j8
make install
#cp -avrf ${ANTIX_PKG_BUILD}/libpng/usr/local/* ${ANTIX_TOOLS}/${ANTIX_TARGET}/
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libpng*.so* ${ANTIX_ROOT}/usr/lib
cd ${ANTIX_BASE}/source
rm -rf ${dir}
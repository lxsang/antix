#! /bin/bash
# depend on freetype
# maybe glib
set -e
. ../env.sh
. ../toolchain.sh
dir="harfbuzz-2.1.1"
cd ${ANTIX_BASE}/source
if [ ! -f "${dir}.tar.bz2" ]; then
    # download it
    wget https://www.freedesktop.org/software/harfbuzz/release/${dir}.tar.bz2
fi
tar xvf ${dir}.tar.bz2
cd ${dir}
# configure cross platform
./configure --prefix=${ANTIX_TOOLS}/${ANTIX_TARGET}/\
    --build=${ANTIX_TARGET}\
    --host=${ANTIX_TARGET} \
    --with-fontconfig=no \
    --with-glib=no \
    --with-cairo=no \
    --with-sysroot=${ANTIX_ROOT} \
    --with-freetype=yes
# -arch ${ANTIX_ARCH}
make -j8
make install
#cp -avrf ${ANTIX_PKG_BUILD}/harfbuzz/usr/* ${ANTIX_TOOLS}/${ANTIX_TARGET}/
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libharfbuzz*.so* ${ANTIX_ROOT}/usr/lib
#cp -avrf ${ANTIX_PKG_BUILD}/freetype/usr/local/bin/freetype-config ${ANTIX_ROOT}/usr/bin
cd ${ANTIX_BASE}/source
rm -rf  ${dir}
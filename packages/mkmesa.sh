#! /bin/bash
# depends on
#   libdrm
#   expat
set -e
. ../env.sh
. ../toolchain.sh
dir="mesa-18.2.5"
cd ${ANTIX_BASE}/source
if [ ! -f "${dir}.tar.xz" ]; then
    # download it
    wget ftp://ftp.freedesktop.org/pub/mesa/${dir}.tar.xz
fi
tar xvf ${dir}.tar.xz
cd ${dir}
driver="swrast"
if [  "${ANTIX_BOARD}" = "rpi0" ]; then
    driver="swrast,vc4"
fi
# configure cross platform
./configure --enable-gles2 --enable-gles1 --disable-glx \
    --prefix=${ANTIX_TOOLS}/${ANTIX_TARGET}\
    --build=${ANTIX_HOST}\
    --host=${ANTIX_TARGET}\
    --with-platforms=drm --enable-gbm --enable-shared-glapi \
    --with-gallium-drivers=${driver}\
    --with-dri-drivers=swrast\
    --disable-dri3
   
make -j10
make install

cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libEGL.so* ${ANTIX_ROOT}/usr/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libgbm.so* ${ANTIX_ROOT}/usr/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libglapi.so* ${ANTIX_ROOT}/usr/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libGLES*.so* ${ANTIX_ROOT}/usr/lib
cd ${ANTIX_BASE}/source
rm -rf  ${dir}

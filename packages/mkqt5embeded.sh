#! /bin/bash
set -e
. ../env.sh
# depends on mesa  
# install flex
#. ../toolchain.sh
cd ${ANTIX_BASE}/source
dir="qt-everywhere-src-5.11.2"
if [ ! -f "${dir}.tar.xz" ]; then
    # download it
    wget https://download.qt.io/archive/qt/5.11/5.11.2/single/qt-everywhere-src-5.11.2.tar.xz
fi
if [ ! -d "${dir}" ]; then
    tar xvf ${dir}.tar.xz
fi
if [  "${ANTIX_BOARD}" = "rpi0" ]; then
    dev="linux-rasp-pi-g++"
    test ! -d "${ANTIX_TOOLS}/${ANTIX_TARGET}/opt/" && mkdir -pv "${ANTIX_TOOLS}/${ANTIX_TARGET}/opt/"
    test ! -L "${ANTIX_TOOLS}/${ANTIX_TARGET}/opt/vc" && ln -s "${ANTIX_TOOLS}/${ANTIX_TARGET}" "${ANTIX_TOOLS}/${ANTIX_TARGET}/opt/vc"
else
    # openGL must be previously compiled here
    dev="linux-arm-generic-g++"
fi
cd ${dir}
# configure cross platform
#set +e
#make confclean
#set -e
test -d build && rm -r build
mkdir build
cd build
PKG_CONFIG_SYSROOT_DIR=/ \
    ../configure -release -opengl es2 \
    -device ${dev} \
    -opensource -confirm-license \
    -device-option CROSS_COMPILE=${ANTIX_TARGET}- -sysroot ${ANTIX_TOOLS}/${ANTIX_TARGET} \
    -prefix /usr/local/qt5\
    -I "${ANTIX_TOOLS}/${ANTIX_TARGET}/include/c++/6.2.0"\
    -I "${ANTIX_TOOLS}/${ANTIX_TARGET}/include/"\
    -extprefix ${ANTIX_PKG_BUILD}/qt
make -j8
make install

#cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libharfbuzz*.so* ${ANTIX_ROOT}/usr/lib

cd ${ANTIX_BASE}/source
#rm -rf  ${dir}
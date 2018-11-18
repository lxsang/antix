#! /bin/bash
set -e
. ../env.sh
# depends on mesa  
# install flex
. ../toolchain.sh
cd ${ANTIX_BASE}/source
dir="qt-everywhere-opensource-src-5.9.0"
if [ ! -f "${dir}.tar.xz" ]; then
    # download it
    wget https://download.qt.io/archive/qt/5.9/5.9.0/single/qt-everywhere-opensource-src-5.9.0.tar.xz
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
    -nomake examples -no-compile-examples \
    -skip qtlocation -skip qtmultimedia \
    QMAKE_CFLAGS_ISYSTEM=\
    -no-openssl
#exit 0
# we disable openssl for now, since wt doesnot support libressl
# will figureout how to install openssl
# fix -isystem bug
# dirty hack, ignore first fail, fix -isystem issue, then rebuild
#set +e
make -j 10
make install
echo "Installed"

#copy only needed libs
mkdir -p ${ANTIX_ROOT}/opt/qt5/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/local/qt5/lib/libQt5Widgets.so* ${ANTIX_ROOT}/opt/qt5/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/local/qt5/lib/libQt5Gui.so* ${ANTIX_ROOT}/opt/qt5/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/local/qt5/lib/libQt5Core.so* ${ANTIX_ROOT}/opt/qt5/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/local/qt5/lib/libQt5EglFSDeviceIntegration.so* ${ANTIX_ROOT}/opt/qt5/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/local/qt5/lib/libQt5DBus.so* ${ANTIX_ROOT}/opt/qt5/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/local/qt5/lib/libQt5Network.so* ${ANTIX_ROOT}/opt/qt5/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/local/qt5/lib/libQt5Quick.so* ${ANTIX_ROOT}/opt/qt5/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/local/qt5/lib/libQt5WebView.so* ${ANTIX_ROOT}/opt/qt5/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/local/qt5/lib/libQt5Qml.so* ${ANTIX_ROOT}/opt/qt5/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/local/qt5/lib/libQt5Svg.so* ${ANTIX_ROOT}/opt/qt5/lib
cd ${ANTIX_BASE}/source
#rm -rf  ${dir}
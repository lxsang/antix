#! /bin/bash
set -e
. ../env.sh
. ../toolchain.sh
dir="qtwebengine"
cd ${ANTIX_BASE}/source
if [ ! -d "${dir}" ]; then
    # download it
    git clone http://code.qt.io/qt/qtwebengine.git
fi
cd  ${dir}
git submodule update --init
cd ../
test -d "qt-we-build" && rm -r "qt-we-build"
mkdir "qt-we-build"
cd "qt-we-build"
${ANTIX_TOOLS}/${ANTIX_TARGET}/local/qt5/bin/qmake ../${dir}/qtwebengine.pro 
# configure cross platform
   
make -j8
#make install

#cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libharfbuzz*.so* ${ANTIX_ROOT}/usr/lib

cd ${ANTIX_BASE}/source
#rm -rf  ${dir}
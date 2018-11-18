#! /bin/bash
# depend on
# - freetype
# -fontconfig
# -harfbuzz
# -fribidi
# -glib 2.0
set -e
. ../env.sh
. ../toolchain.sh
dir="qtwebkit"
cd ${ANTIX_BASE}/source
if [ ! -d "${dir}" ]; then
    # download it
    git clone https://github.com/qt/qtwebkit
    git checkout 5.9
else
    cd ${dir}
    git stash
    cd ../
fi
# patch the file

test -d qt-webkit-build && rm -r qt-webkit-build
mkdir qt-webkit-build
cd qt-webkit-build
perl ../../Tools/Scripts/build-webkit --qt --qmake="/home/mrsang/antix-rpi0-musl/cross-tools//arm-linux-musleabihf/local/qt5/bin/qmake" --release --no-webgl --no-3d-rendering --only-webkit
# qmake

# configure cross platform

   
make -j8
make install

#cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libharfbuzz*.so* ${ANTIX_ROOT}/usr/lib

cd ${ANTIX_BASE}/source
#rm -rf  ${dir}
#! /bin/bash
set -e
. ../env.sh
. ../toolchain.sh
file="libxml2-git-snapshot"
dir="libxml2-2.9.7"
cd ${ANTIX_BASE}/source
if [ ! -f "${file}.tar.gz" ]; then
    # download it
    wget ftp://xmlsoft.org/libxml2/${file}.tar.gz
fi
tar xvf ${file}.tar.gz
cd ${dir}
# configure cross platform\
./configure --prefix=${ANTIX_TOOLS}/${ANTIX_TARGET} --without-lzma --without-python --disable-static --without-icu --host=arm-linux
# -arch ${ANTIX_ARCH}
make -j8
make install
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libxml2.so* ${ANTIX_ROOT}/usr/lib
cd ${ANTIX_BASE}/source
rm -rf  ${dir}

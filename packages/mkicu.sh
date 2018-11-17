#! /bin/bash

set -e
. ../env.sh
#. ../toolchain.sh
dir="icu4c-63_1-src"
cd ${ANTIX_BASE}/source
if [ ! -f "${dir}.tgz" ]; then
    # download it
    wget http://download.icu-project.org/files/icu4c/63.1/icu4c-63_1-src.tgz
fi
tar xvf ${dir}.tgz
cd icu/source
if [ ! -d "${ANTIX_BASE}/source/icu/source/host-build/out" ]; then
    mkdir -p host-build
    cd host-build
    ../configure --prefix=${ANTIX_BASE}/source/icu/source/host-build/out\
        --disable-samples --disable-tests
    make -j 8
    make install
    cd ../
fi
mkdir -p cross-build
cd cross-build
# configure cross platform
../configure --prefix=${ANTIX_TOOLS}/${ANTIX_TARGET}\
    --build=${ANTIX_HOST}\
    --host=${ANTIX_TARGET}\
    --disable-samples --disable-tests\
    --with-cross-build=${ANTIX_BASE}/source/icu/source/host-build
   
make -j8
make install

cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libicu*.so* ${ANTIX_ROOT}/usr/lib

cd ${ANTIX_BASE}/source
rm -rf  icu

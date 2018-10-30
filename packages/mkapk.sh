#! /bin/bash
set -e
. ../env.sh
. ../toolchain.sh
cd ${ANTIX_BASE}/source
if [ ! -d "apk-tools" ]; then
    # download it
    git clone https://github.com/lxsang/apk-tools
    cd apk-tools
else
    cd apk-tools
    git stash
fi
git checkout 2.8-stable
wget https://github.com/lxsang/antix/raw/master/packages/apk-tools-2.8.2.patch
patch -Np1 -i apk-tools-2.8.2.patch
make clean
make -j 8 LUAAPK= DESTDIR=${ANTIX_PKG_BUILD}/apk CROSS_COMPILE="${ANTIX_TARGET}-"  CFLAGS="-Wno-unused-result" static
make LUAAPK= CROSS_COMPILE="${ANTIX_TARGET}-" DESTDIR=${ANTIX_PKG_BUILD}/apk install
cp ${ANTIX_PKG_BUILD}/apk/sbin/apk ${ANTIX_ROOT}/usr/bin
cd ${ANTIX_BASE}/source
rm -rf apk-tools
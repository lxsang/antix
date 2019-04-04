#! /bin/bash
set -e
. ../env.sh
. ../toolchain.sh
VERSION="3.1.3"
cd ${ANTIX_BASE}/source
if [ ! -f "rsync-$VERSION.tar.gz" ]; then
    # download it
    wget https://download.samba.org/pub/rsync/src/rsync-$VERSION.tar.gz
fi
set e+
rm -rf rsync-$VERSION
tar xvf rsync-$VERSION.tar.gz
cd rsync-$VERSION
#autoconf

./configure --host=${ANTIX_TARGET} --prefix=${ANTIX_PKG_BUILD}/rsync
#
make -j 8
make install
cp -av ${ANTIX_PKG_BUILD}/rsync/bin/rsync ${ANTIX_ROOT}/usr/bin/

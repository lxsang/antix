#! /bin/bash
set -e
. ../env.sh
. ../toolchain.sh
NAME="picocom"
VERSION="3.1"
BASENAME=${NAME}-${VERSION}
cd ${ANTIX_BASE}/source
if [ ! -f "$BASENAME.tar.gz" ]; then
    # download it
    wget -O "$BASENAME.tar.gz"  https://github.com/npat-efault/picocom/archive/$VERSION.tar.gz
fi
rm -rf $BASENAME
tar xvf $BASENAME.tar.gz
cd $BASENAME
make clean
make
cp -av picocom ${ANTIX_ROOT}/usr/bin/

#
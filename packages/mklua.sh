#! /bin/bash
set -e
. ../env.sh
. ../toolchain.sh
NAME="lua"
VERSION="5.3.5"
BASENAME=${NAME}-${VERSION}
cd ${ANTIX_BASE}/source
if [ ! -f "$BASENAME.tar.gz" ]; then
    # download it
    wget  http://www.lua.org/ftp/$BASENAME.tar.gz
fi
rm -rf $BASENAME
tar xvf $BASENAME.tar.gz
cd $BASENAME
make clean
make -j 8 CC=${ANTIX_TARGET}-gcc linux
cp -av src/{lua,luac} ${ANTIX_ROOT}/usr/bin/

#
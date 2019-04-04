#! /bin/bash
# dependencies
# curl, expat
set -e
. ../env.sh
. ../toolchain.sh
NAME="htop"
VERSION="2.2.0"
BASENAME=${NAME}-${VERSION}
cd ${ANTIX_BASE}/source
if [ ! -f "$BASENAME.tar.gz" ]; then
    # download it
    wget https://hisham.hm/htop/releases/$VERSION/$BASENAME.tar.gz
fi
set e+
rm -rf $BASENAME
tar xvf $BASENAME.tar.gz
cd $BASENAME
./configure \
    --host=${ANTIX_TARGET} \
    --prefix=${ANTIX_PKG_BUILD}/${NAME}
#
make clean
make -j 8
make install
cp -av ${ANTIX_PKG_BUILD}/htop/bin/htop ${ANTIX_ROOT}/usr/bin/

#
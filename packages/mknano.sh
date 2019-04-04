#! /bin/bash
# this is curently BUGGG
# not work, need to fix
set -e
. ../env.sh
. ../toolchain.sh
NAME="nano"
VERSION="4.0"
BASENAME=${NAME}-${VERSION}
cd ${ANTIX_BASE}/source
if [ ! -f "$BASENAME.tar.gz" ]; then
    # download it
    wget https://www.nano-editor.org/dist/v4/$BASENAME.tar.gz
fi
rm -rf $BASENAME
tar xvf $BASENAME.tar.gz
cd $BASENAME
./configure \
    --build=${ANTIX_HOST} \
    --target=${ANTIX_TARGET} \
    --host=${ANTIX_TARGET} \
    --prefix=${ANTIX_PKG_BUILD}/${NAME} \
    NCURSESW_CFLAGS="-I${ANTIX_TOOLS}/${ANTIX_TARGET}/include ${NCURSESW_CFLAGS}"
exit 0
make clean
make -j 8
make install
cp -av ${ANTIX_PKG_BUILD}/htop/bin/htop ${ANTIX_ROOT}/usr/bin/

#
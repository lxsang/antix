#! /bin/bash
set -e
. ../env.sh
. ../toolchain.sh
cd ${ANTIX_BASE}/source
if [ ! -d "tree-packaging" ]; then
    # download it
    git clone https://salsa.debian.org/debian/tree-packaging.git
    cd tree-packaging
else
    cd tree-packaging
    git stash
fi
# support for cross compile
sed -i -E 's/CC=gcc/#CC=gcc/' Makefile
make clean
CC=${CC} make
# install it to the rootfs
cp -av tree ${ANTIX_ROOT}/usr/bin/
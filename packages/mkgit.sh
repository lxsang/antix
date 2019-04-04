#! /bin/bash
# NOTES:    dependencies
#           curl, expat
set -e
. ../env.sh
. ../toolchain.sh
VERSION="2.9.5"
cd ${ANTIX_BASE}/source
if [ ! -f "git-$VERSION.tar.gz" ]; then
    # download it
    wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-$VERSION.tar.gz
fi
set e+
rm -rf git-$VERSION
tar xvf git-$VERSION.tar.gz
cd git-$VERSION
#autoconf

./configure --host=${ANTIX_TARGET} --prefix=${ANTIX_PKG_BUILD}/git --without-iconv
#
make -j 8
make install
#cp -av ${ANTIX_PKG_BUILD}/git/bin/git ${ANTIX_ROOT}/usr/bin/

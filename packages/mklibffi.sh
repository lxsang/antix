#! /bin/bash

set -e
. ../env.sh
. ../toolchain.sh
dir="libffi-3.2"
cd ${ANTIX_BASE}/source
if [ ! -f "${dir}.tar.gz" ]; then
    # download it
    wget https://sourceware.org/ftp/libffi/${dir}.tar.gz
fi
tar xvf ${dir}.tar.gz
cd ${dir}
sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' \
    -i include/Makefile.in

sed -e '/^includedir/ s/=.*$/=@includedir@/' \
    -e 's/^Cflags: -I${includedir}/Cflags:/' \
    -i libffi.pc.in 
# configure cross platform
./configure --prefix=${ANTIX_TOOLS}/${ANTIX_TARGET}\
    --build=${ANTIX_HOST}\
    --host=${ANTIX_TARGET}
   
make -j8
make install

cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libffi.so* ${ANTIX_ROOT}/usr/lib

cd ${ANTIX_BASE}/source
rm -rf  ${dir}
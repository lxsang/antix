#! /bin/bash
set -e
. ../env.sh
. ../toolchain.sh
echo ${CC}

cd ~/antix-${ANTIX_BOARD}/source
if [ ! -f "zlib-1.2.11.tar.gz" ]; then
    # download it
    wget https://zlib.net/zlib-1.2.11.tar.gz
fi
tar xvf zlib-1.2.11.tar.gz
cd zlib-1.2.11
CFLAGS="-Os" ./configure --shared
make -j 8
make prefix=${ANTIX_TOOLS}/${ANTIX_TARGET} install
cp -v ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libz.so.1.2.11 ${ANTIX_ROOT}/lib/
ln -sv libz.so.1.2.11 ${ANTIX_ROOT}/lib/libz.so.1
cd ~/antix-${ANTIX_BOARD}/source
rm -rf zlib-1.2.11
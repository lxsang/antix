#! /bin/bash
# build wiring pi library
# for raspberry Pi flavor devices
set -e
. ../env.sh
. ../toolchain.sh
cd ${ANTIX_BASE}/source
if [ ! -d "avrdude-6.3" ]; then
    # download it
    git clone https://github.com/arie-g/avrdude-6.3
    
fi
if [ ! -f "avrdude6.3.patch" ]; then
    wget https://github.com/lxsang/antix/blob/master/packages/avrdude6.3.patch
fi

cd avrdude-6.3
# patch it
 patch -Np1 -i avrdude6.3.patch 
# now configure the code
./bootstrap
./configure \
    --build=${ANTIX_HOST}\
    --host=${ANTIX_TARGET}\
    --enable-linuxgpio
exit 0
make clean
make
cp -av avrdude ${ANTIX_ROOT}/usr/bin/
mkdir -p ${ANTIX_ROOT}/usr/local/etc/
cp -av avrdude.conf ${ANTIX_ROOT}/usr/local/etc/
exit 0
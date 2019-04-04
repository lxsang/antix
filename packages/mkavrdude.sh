#! /bin/bash
# build wiring pi library
# for raspberry Pi flavor devices
set -e
. ../env.sh
. ../toolchain.sh
cd ${ANTIX_BASE}/source
if [ ! -d "avrdude" ]; then
    # download it
    git clone https://github.com/sigmike/avrdude
    cd avrdude
else
    cd avrdude
fi
# now configure the code
./bootstrap
./configure \
    --build=${ANTIX_HOST}\
    --host=${ANTIX_TARGET}
make clean
make
cp -av avrdude ${ANTIX_ROOT}/usr/bin/
mkdir -p ${ANTIX_ROOT}/usr/local/etc/
cp -av avrdude.conf ${ANTIX_ROOT}/usr/local/etc/
exit 0
#! /bin/bash
# build wiring pi library
# for raspberry Pi flavor devices
set -e
. ../env.sh
. ../toolchain.sh
cd ${ANTIX_BASE}/source
if [ ! -f "wiringPi.tar.gz" ]; then
    # download it
    wget -O wiringPi.tar.gz "https://git.drogon.net/?p=wiringPi;a=snapshot;h=36fb7f187fcb40eb648109dc0fcce40e78b19333;sf=tgz"
fi
if [ -d "wiringPi-36fb7f1" ]; then
    rm -r "wiringPi-36fb7f1"
fi
tar xvf wiringPi.tar.gz
cd "wiringPi-36fb7f1"
cd wiringPi

# git checkout 2.8-stable
#wget https://github.com/lxsang/antix/raw/master/packages/apk-tools-2.8.2.patch
# patch -Np1 -i apk-tools-2.8.2.patch
VERSION=$(cat ../VERSION)
echo "Version  is $VERSION"
# 1. make wiringPi
make clean
make -j 8 DESTDIR=${ANTIX_TOOLS}/${ANTIX_TARGET} PREFIX=
make -j 8  LDCONFIG= DESTDIR=${ANTIX_TOOLS}/${ANTIX_TARGET} PREFIX= install
# 2. make wiringPiDev
cd ../devLib
make clean
make -j 8 DESTDIR=${ANTIX_TOOLS}/${ANTIX_TARGET} PREFIX=
make -j 8  LDCONFIG= DESTDIR=${ANTIX_TOOLS}/${ANTIX_TARGET}  PREFIX= install
# make gpio tools
cd ../gpio
make clean
if [ ! -r "${ANTIX_PKG_BUILD}/gpio" ]; then
    mkdir -p "${ANTIX_PKG_BUILD}/gpio/bin/"
fi
make -j 8 DESTDIR=${ANTIX_PKG_BUILD}/gpio PREFIX=
make -j 8  DESTDIR=${ANTIX_PKG_BUILD}/gpio WIRINGPI_SUID=0 PREFIX= install

# now install everything to the root fs
cp -av ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libwiringPi.so.$VERSION ${ANTIX_ROOT}/usr/lib/libwiringPi.so
cp -av ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libwiringPiDev.so.$VERSION ${ANTIX_ROOT}/usr/lib/libwiringPiDev.so
cp -av ${ANTIX_PKG_BUILD}/gpio/bin/gpio ${ANTIX_ROOT}/usr/bin
exit 0

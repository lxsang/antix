#! /bin/bash
set -e
. ../env.sh
. ../toolchain.sh
echo ${CC}

cd ${ANTIX_BASE}/source
if [ ! -f "wireless_tools.29.tar.gz" ]; then
    # download it
    wget --no-check-certificate http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.29.tar.gz
fi
tar xvf wireless_tools.29.tar.gz
cd wireless_tools.29
sed -i -E "s/ ar/${ANTIX_TARGET}\-ar/" Makefile
sed -i -E "s/gcc/${ANTIX_TARGET}\-gcc/" Makefile
sed -i -E "s/ranlib/${ANTIX_TARGET}\-ranlib/" Makefile
make PREFIX=${ANTIX_PKG_BUILD}/wireless/usr
set +e
make install PREFIX=${ANTIX_PKG_BUILD}/wireless/usr
set -e
cp ${ANTIX_PKG_BUILD}/wireless/usr/lib/* ${ANTIX_ROOT}/usr/lib
cp ${ANTIX_PKG_BUILD}/wireless/usr/sbin/* ${ANTIX_ROOT}/usr/sbin
cd ${ANTIX_BASE}/source
rm -rf wireless_tools.29
# iw tools is only allow wep connection
# to connect to wpa wifi, we need wpa_supplicant
if [ ! -f "wpa_supplicant-2.6.tar.gz" ]; then
    # download it
    wget http://w1.fi/releases/wpa_supplicant-2.6.tar.gz
fi
tar xvf wpa_supplicant-2.6.tar.gz
cd wpa_supplicant-2.6/wpa_supplicant
# cross compile it
cp defconfig .config
make CC=${ANTIX_TARGET}-gcc
make install DESTDIR=${ANTIX_PKG_BUILD}/wireless/usr
cd ${ANTIX_BASE}/source
rm -rf  ${ANTIX_PKG_BUILD}/wireless wpa_supplicant-2.6
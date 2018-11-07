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
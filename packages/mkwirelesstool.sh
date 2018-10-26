#! /bin/bash
set -e
. ../env.sh
. ../toolchain.sh
echo ${CC}

cd ~/antix/source
if [ ! -f "wireless_tools.29.tar.gz" ]; then
    # download it
    wget http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.29.tar.gz
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
rm -rf wireless_tools.29
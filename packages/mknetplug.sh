#! /bin/bash
set -e
. ../env.sh
. ../toolchain.sh
echo ${CC}

cd ~/antix/source
if [ ! -f "netplug-1.2.9.2.tar.bz2" ]; then
    # download it
    wget http://www.red-bean.com/~bos/netplug/netplug-1.2.9.2.tar.bz2
    wget https://raw.githubusercontent.com/lxsang/antix/master/netplug-1.2.9.2-fixes-1.patch
fi
tar xvf netplug-1.2.9.2.tar.bz2
cd netplug-1.2.9.2
patch -Np1 -i ../netplug-1.2.9.2-fixes-1.patch
make -j 8
make DESTDIR=${ANTIX_ROOT} install
# make boot script
cd ${ANTIX_BASE}/source
tar xvf bootscripts-embedded-HEAD.tar.gz
cd bootscripts-embedded
make DESTDIR=${ANTIX_ROOT} install-netplug
cd ${ANTIX_BASE}/source
rm -r bootscripts-embedded
cd ${ANTIX_BASE}/source

cd ${ANTIX_BASE}/source
rm -rf netplug-1.2.9.2
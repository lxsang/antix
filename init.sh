#! /bin/bash
set -e
. env.sh
mkdir -p ~/antix/{source,rootfs,boot,cross-tools,pkg-build}
# now grab the source
cd ${ANTIX_BASE}/source
wget http://ftp.gnu.org/gnu/binutils/binutils-2.27.tar.bz2
wget http://busybox.net/downloads/busybox-1.24.2.tar.bz2
wget http://sethwklein.net/iana-etc-2.30.tar.bz2
wget http://www.kernel.org/pub/linux/kernel/v4.x/linux-4.9.22.tar.xz
wget http://www.musl-libc.org/releases/musl-1.1.16.tar.gz
# switch to glib
wget http://mirror.ibcp.fr/pub/gnu/libc/glibc-2.28.tar.xz
wget http://mirror.ibcp.fr/pub/gnu/libc/glibc-ports-2.8.tar.gz
wget http://gcc.gnu.org/pub/gcc/releases/gcc-6.2.0/gcc-6.2.0.tar.bz2
wget http://ftp.gnu.org/gnu/gmp/gmp-6.1.1.tar.bz2
wget https://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz
wget http://ftp.gnu.org/gnu/mpfr/mpfr-3.1.4.tar.bz2
wget https://github.com/lxsang/antix/raw/master/bootscripts-embedded-HEAD.tar.gz
#wget http://matt.ucc.asn.au/dropbear/releases/dropbear-2013.60.tar.bz2
#wget http://www.red-bean.com/~bos/netplug/netplug-1.2.9.2.tar.bz2
#wget http://downloads.sourceforge.net/libpng/zlib-1.2.8.tar.gz
#wget --no-check-certificate http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.29.tar.gz
# patch
wget http://patches.clfs.org/embedded-dev/iana-etc-2.30-update-2.patch
#wget http://patches.clfs.org/embedded-dev/netplug-1.2.9.2-fixes-1.patch
wget https://raw.githubusercontent.com/lxsang/antix/master/0029-ethernet-add-sun8i-emac-driver.patch
wget https://github.com/lxsang/antix/raw/master/sun8i-h3-nanopi-neo.patch
wget https://github.com/lxsang/antix/raw/master/sun8i-h3.patch
# other packag
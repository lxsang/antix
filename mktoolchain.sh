#! /bin/bash
set -e
. env.sh
mkdir -p ${ANTIX_TOOLS}/${ANTIX_TARGET}
ln -sfv . ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr
# the linux header
cd ~/antix/source
tar xvf linux-4.9.22.tar.xz 
cd linux-4.9.22
make mrproper
make ARCH=arm headers_check
make ARCH=arm INSTALL_HDR_PATH=${ANTIX_TOOLS}/${ANTIX_TARGET} headers_install
cd ~/antix/source
rm -r linux-4.9.22
# binutil
cd ~/antix/source
tar xvf binutils-2.27.tar.bz2
cd binutils-2.27
mkdir -v ../binutils-build
cd ../binutils-build
../binutils-2.27/configure \
   --prefix=${ANTIX_TOOLS} \
   --target=${ANTIX_TARGET} \
   --with-sysroot=${ANTIX_TOOLS}/${ANTIX_TARGET} \
   --disable-nls \
   --disable-multilib
make configure-host
make -j 8
make install
cd ~/antix/source
rm -r binutils-build binutils-2.27
# gcc 1st
cd ~/antix/source
tar xvf gcc-6.2.0.tar.bz2
cd gcc-6.2.0
tar xf ../mpfr-3.1.4.tar.bz2
mv -v mpfr-3.1.4 mpfr
tar xf ../gmp-6.1.1.tar.bz2
mv -v gmp-6.1.1 gmp
tar xf ../mpc-1.0.3.tar.gz
mv -v mpc-1.0.3 mpc
mkdir -v ../gcc-build
cd ../gcc-build

../gcc-6.2.0/configure \
  --prefix=${ANTIX_TOOLS} \
  --build=${ANTIX_HOST} \
  --host=${ANTIX_HOST} \
  --target=${ANTIX_TARGET} \
  --with-sysroot=${ANTIX_TOOLS}/${ANTIX_TARGET} \
  --disable-nls \
  --disable-shared \
  --without-headers \
  --with-newlib \
  --disable-decimal-float \
  --disable-libgomp \
  --disable-libmudflap \
  --disable-libssp \
  --disable-libatomic \
  --disable-libquadmath \
  --disable-threads \
  --enable-languages=c \
  --disable-multilib \
  --with-mpfr-include=$(pwd)/../gcc-6.2.0/mpfr/src \
  --with-mpfr-lib=$(pwd)/mpfr/src/.libs \
  --with-arch=${ANTIX_ARCH} \
  --with-float=${ANTIX_FLOAT} \
  --with-fpu=${ANTIX_FPU}
 make -j 8 all-gcc all-target-libgcc
 make install-gcc install-target-libgcc
 cd ~/antix/source
 rm -r gcc-6.2.0 gcc-build

# musl
#cd ~/antix/source
#tar xvf musl-1.1.16.tar.gz 
#cd musl-1.1.16/
#./configure \
#  CROSS_COMPILE=${ANTIX_TARGET}- \
#  --prefix=/ \
#  --target=${ANTIX_TARGET}
#make -j 8
#DESTDIR=${ANTIX_TOOLS}/${ANTIX_TARGET} make install
#cd ~/antix/source
#rm -r musl-1.1.16

# 	glibc-2.28.tar.xz
cd ~/antix/source
tar xvf glibc-2.28.tar.xz
cd glibc-2.28
mkdir libc-build
cd libc-build
../configure \
      --prefix=${ANTIX_TOOLS} \
      --host=${ANTIX_HOST} \
      --build=$(../scripts/config.guess) \
      --enable-kernel=3.2 \
      --with-headers=${ANTIX_TOOLS}/${ANTIX_TARGET}/include \
      libc_cv_forced_unwind=yes \
      libc_cv_c_cleanup=yes
make -j 8
make install
cd ~/antix/source
rm -r glibc-2.28

# gcc 2nd
cd ~/antix/source
tar xvf gcc-6.2.0.tar.bz2
cd gcc-6.2.0
tar xf ../mpfr-3.1.4.tar.bz2
mv -v mpfr-3.1.4 mpfr
tar xf ../gmp-6.1.1.tar.bz2
mv -v gmp-6.1.1 gmp
tar xf ../mpc-1.0.3.tar.gz
mv -v mpc-1.0.3 mpc
mkdir -v ../gcc-build
cd ../gcc-build
../gcc-6.2.0/configure \
  --prefix=${ANTIX_TOOLS} \
  --build=${ANTIX_HOST} \
  --host=${ANTIX_HOST} \
  --target=${ANTIX_TARGET} \
  --with-sysroot=${ANTIX_TOOLS}/${ANTIX_TARGET} \
  --disable-nls \
  --enable-languages=c \
  --enable-c99 \
  --enable-long-long \
  --disable-libmudflap \
  --disable-multilib \
  --with-mpfr-include=$(pwd)/../gcc-6.2.0/mpfr/src \
  --with-mpfr-lib=$(pwd)/mpfr/src/.libs \
  --with-arch=${ANTIX_ARCH} \
  --with-float=${ANTIX_FLOAT} \
  --with-fpu=${ANTIX_FPU}
 make -j 8
 make install
 cd ~/antix/source
 rm -r gcc-6.2.0 gcc-build

echo "Finish building the tool chain at: ${ANTIX_TOOLS}"

#! /bin/bash
set -e
. env.sh
mkdir -p ${ANTIX_TOOLS}/${ANTIX_TARGET}
set +e
ln -sfv . ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr
set -e
# the linux header
cd ${ANTIX_BASE}/source
if [ "${ANTIX_BOARD}" = "npineo" ]; then
    tar xvf linux-4.9.22.tar.xz 
    cd linux-4.9.22
else
    cd linux-4.14.y
fi
make mrproper
make ARCH=arm headers_check
make ARCH=arm INSTALL_HDR_PATH=${ANTIX_TOOLS}/${ANTIX_TARGET} headers_install
cd ${ANTIX_BASE}/source
test -d linux-4.9.22 && rm -rf linux-4.9.22
#test -d linux-4.14.y && rm -rf linux-4.14.y
# binutil
cd ${ANTIX_BASE}/source
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
cd ${ANTIX_BASE}/source
rm -rf binutils-build binutils-2.27
# gcc 1st
cd ${ANTIX_BASE}/source
tar xvf gcc-6.2.0.tar.bz2
cd gcc-6.2.0
patch -Np1 -i ../gcc_6.2.0.ubsan.patch
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
 cd ${ANTIX_BASE}/source
 rm -rf gcc-6.2.0 gcc-build

if [ "$ANTIX_LIBC" = "musl" ]; then
    # musl
    cd ${ANTIX_BASE}/source
    tar xvf musl-1.1.18.tar.gz 
    cd musl-1.1.18/
    ./configure \
      CROSS_COMPILE=${ANTIX_TARGET}- \
      --prefix=/ \
      --target=${ANTIX_TARGET}
    make -j 8
    DESTDIR=${ANTIX_TOOLS}/${ANTIX_TARGET} make install
    cd ${ANTIX_BASE}/source
    rm -rf musl-1.1.18
else
    # 	glibc-2.28.tar.xz
    cd ${ANTIX_BASE}/source
    tar xvf glibc-2.28.tar.xz
    cd glibc-2.28
    tar xvf ../glibc-ports-2.8.tar.gz
    mv glibc-ports-2.8 ports
    mkdir -v ../glibc-build
    cd ../glibc-build
    echo "libc_cv_forced_unwind=yes" > config.cache
    echo "libc_cv_c_cleanup=yes" >> config.cache
    echo "libc_cv_arm_tls=yes" >> config.cache
    echo "install_root=${ANTIX_TOOLS}/${ANTIX_TARGET}" > configparms
    CC=gcc ../glibc-2.28/configure --prefix=/usr \
        --host=${ANTIX_TARGET} --build=${ANTIX_HOST} \
        --with-headers=${ANTIX_TOOLS}/${ANTIX_TARGET}/include --cache-file=config.cache
    make install-headers
    #touch ${ANTIX_TOOLS}/${ANTIX_TARGET}/include/gnu/stubs.h
    #install -dv ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/include/bits
    #cp -v bits/stdio_lim.h ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/include/bits
    #cp -v ../glibc-2.28/ports/sysdeps/unix/sysv/linux/arm/nptl/bits/pthreadtypes.h \
    #    ${ANTIX_TOOLS}/${ANTIX_TARGET}/usr/include/bits
    cd ${ANTIX_BASE}/source
    rm -rf glibc-2.28 glibc-build

    # now compile glibc
    cd ${ANTIX_BASE}/source
    tar xvf glibc-2.28.tar.xz
    cd glibc-2.28
    tar xvf ../glibc-ports-2.8.tar.gz
    mv glibc-ports-2.8 ports
    mkdir -v ../glibc-build
    cd ../glibc-build
    # patch install error
    for file in `find ../glibc-2.28/ports/ -name 'libm-test-ulps'`; do
        cp "$file" "$file-name";
    done
    echo "libc_cv_forced_unwind=yes" > config.cache
    echo "libc_cv_c_cleanup=yes" >> config.cache
    echo "install_root=${ANTIX_TOOLS}/${ANTIX_TARGET}" > configparms

    BUILD_CC="gcc" CC="${ANTIX_TARGET}-gcc" \
        AR="${ANTIX_TARGET}-ar" RANLIB="${ANTIX_TARGET}-ranlib" \
        ../glibc-2.28/configure --prefix=/usr --libexecdir=/usr/lib/glibc \
        --host=${ANTIX_TARGET} --build=${ANTIX_HOST} \
        --disable-multilib \
        --disable-profile \
        --with-arch=${ANTIX_ARCH} \
        --with-fpu=${ANTIX_FPU} \
        --with-float=${ANTIX_FLOAT}\
        --enable-add-ons \
        --with-tls --enable-kernel=3.2 --with-__thread \
        --with-binutils=${ANTIX_TOOLS}/bin \
        --with-headers=${ANTIX_TOOLS}/${ANTIX_TARGET}/include \
        --cache-file=config.cache
    make -j 8
    make install
    cd ${ANTIX_BASE}/source
    rm -rf glibc-2.28 glibc-build
fi
# gcc 2nd
cd ${ANTIX_BASE}/source
tar xvf gcc-6.2.0.tar.bz2
cd gcc-6.2.0
#patch
patch -Np1 -i ../gcc_6.2.0.ubsan.patch
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
  --enable-languages=c,c++ \
  --enable-c99 \
  --enable-long-long \
  --disable-libmudflap \
  --disable-multilib \
  --with-mpfr-include=$(pwd)/../gcc-6.2.0/mpfr/src \
  --with-mpfr-lib=$(pwd)/mpfr/src/.libs \
  --with-arch=${ANTIX_ARCH} \
  --with-float=${ANTIX_FLOAT} \
  --with-fpu=${ANTIX_FPU}\
  --disable-libsanitizer
 make -j 8
 make install
 cd ${ANTIX_BASE}/source
 rm -rf gcc-6.2.0 gcc-build

echo "Finish building the tool chain at: ${ANTIX_TOOLS}"

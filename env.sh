#! /bin/bash
export ANTIX_BOARD=rpi0
export ANTIX_ARCH=armv6zk
export ANTIX_FLOAT=hard
export ANTIX_FPU=vfp
export ANTIX_DST=bcm2*.dtb
export ANTIX_KERNEL_CONFIG=bcmrpi_defconfig
export ANTIX_UBOOT_CONFIG=rpi_config
export ANTIX_UBIN=u-boot.bin
export ANTIX_LIBC=musl
export ANTIX_BASE=~/antix-${ANTIX_BOARD}-${ANTIX_LIBC}
export ANTIX_ROOT=${ANTIX_BASE}/rootfs/
export ANTIX_BOOT=${ANTIX_BASE}/boot/
export ANTIX_TOOLS=${ANTIX_BASE}/cross-tools/
export ANTIX_PKG_BUILD=${ANTIX_BASE}/pkg-build/
export ANTIX_TARGET=arm-linux-${ANTIX_LIBC}eabihf
export ANTIX_HOST=$(echo ${MACHTYPE} | sed 's/-[^-]*/-cross/')
export PATH=${ANTIX_TOOLS}/bin:/bin:/usr/bin

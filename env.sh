#! /bin/bash
export ANTIX_BOARD=rpi0
export ANTIX_ARCH=armv6
export ANTIX_FLOAT=hard
export ANTIX_FPU=vfp
export ANTIX_DST=bcm2835-rpi-zero.dtb
export ANTIX_KERNEL_CONFIG=bcm2835_defconfig
export ANTIX_UBOOT_CONFIG=rpi_config
export ANTIX_UBIN=u-boot.bin
export ANTIX_ROOT=~/antix-${ANTIX_BOARD}/rootfs/
export ANTIX_BOOT=~/antix-${ANTIX_BOARD}/boot/
export ANTIX_TOOLS=~/antix-${ANTIX_BOARD}/cross-tools/
export ANTIX_PKG_BUILD=~/antix-${ANTIX_BOARD}/pkg-build/
export ANTIX_LIBC=gnu
export ANTIX_TARGET=arm-linux-${ANTIX_LIBC}eabihf
export ANTIX_HOST=${MACHTYPE}
export PATH=${ANTIX_TOOLS}/bin:/bin:/usr/bin
mkdir -p ~/antix-${ANTIX_BOARD}/{source,rootfs,boot,cross-tools,pkg-build}

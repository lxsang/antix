#! /bin/bash
export ANTIX_ROOT=~/antix/rootfs/
export ANTIX_BOOT=~/antix/boot/
export ANTIX_TOOLS=~/antix/cross-tools/
export ANTIX_LIBC=musl #or gnu
export ANTIX_TARGET=arm-linux-${ANTIX_LIBC}eabihf
export ANTIX_ARCH=armv7-a
export ANTIX_FLOAT=hard
export ANTIX_FPU=vfp
export ANTIX_HOST=$(echo ${MACHTYPE} | sed "s/-[^-]*/-cross/")
export PATH=${ANTIX_TOOLS}/bin:/bin:/usr/bin
export ANTIX_DST=sun8i-h3-nanopi-neo.dtb
export ANTIX_PKG_BUILD=~/antix/pkg-build/
export ANTIX_KERNEL_CONFIG=sunxi_defconfig
export ANTIX_UBOOT_CONFIG=nanopi_neo_defconfig
export ANTIX_UBIN=u-boot-sunxi-with-spl.bin
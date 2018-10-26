#! /bin/bash
export ANTIX_ROOT=~/antix/rootfs/
export ANTIX_BOOT=~/antix/boot/
export ANTIX_TOOLS=~/antix/cross-tools/
export ANTIX_LIBC=musl #or gnu
# nano pi neo: npineo
export ANTIX_BOARD=rpi0
export ANTIX_TARGET=arm-linux-${ANTIX_LIBC}eabihf
# nanopi neo: armv7-a
# rpi zero: armv6
export ANTIX_ARCH=armv6
export ANTIX_FLOAT=hard
export ANTIX_FPU=vfp
export ANTIX_HOST=$(echo ${MACHTYPE} | sed "s/-[^-]*/-cross/")
export PATH=${ANTIX_TOOLS}/bin:/bin:/usr/bin
# nano pineo: sun8i-h3-nanopi-neo.dtb
# rpi zero: bcm2835-rpi-zero.dtb
export ANTIX_DST=bcm2835-rpi-zero.dtb
export ANTIX_PKG_BUILD=~/antix/pkg-build/
# nano pi neo: sunxi_defconfig
# rpi: zero bcm2835_defconfig
export ANTIX_KERNEL_CONFIG=bcm2835_defconfig
# nano pi neo: nanopi_neo_defconfig
# rpi zero: rpi_config
export ANTIX_UBOOT_CONFIG=rpi_config
# nano pi neo: u-boot-sunxi-with-spl.bin
# rpi0: 
export ANTIX_UBIN=u-boot-sunxi-with-spl.bin
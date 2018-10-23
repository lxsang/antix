#! /bin/bash
export ANTIX_ROOT=~/antix/rootfs/
export ANTIX_BOOT=~/antix/boot/
export ANTIX_TOOLS=~/antix/cross-tools/
export ANTIX_TARGET=arm-linux-gnueabihf
export ANTIX_ARCH=armv7-a
export ANTIX_FLOAT=hard
export ANTIX_FPU=vfp
export ANTIX_HOST=$(echo ${MACHTYPE} | sed "s/-[^-]*/-cross/")
export PATH=${ANTIX_TOOLS}/bin:/bin:/usr/bin
export ANTIX_DST=sun8i-h3-nanopi-neo.dtb

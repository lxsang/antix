#! /bin/bash
set -e
. env.sh
cd ~/antix/source
#tar xvf linux-4.9.22.tar.xz 
cd linux-4.9.22
set +e
patch -Np1 -i ../0029-ethernet-add-sun8i-emac-driver.patch
patch -Np1 -i ../sun8i-h3-nanopi-neo.dts
patch -Np1 -i ../sun8i-h3-nanopi-neo.dtsi
set -e
make mrproper
#wget https://raw.githubusercontent.com/lxsang/antix/master/nanopi-config-4.9.22
#mv nanopi-config-4.9.22 .config
make ARCH=arm CROSS_COMPILE=${ANTIX_TARGET}- ${ANTIX_KERNEL_CONFIG}
make ARCH=arm CROSS_COMPILE=${ANTIX_TARGET}- menuconfig
make -j 8 ARCH=arm CROSS_COMPILE=${ANTIX_TARGET}-
make ARCH=arm CROSS_COMPILE=${ANTIX_TARGET}- \
    INSTALL_MOD_PATH=${ANTIX_ROOT} modules_install
cp arch/arm/boot/zImage ${ANTIX_BOOT}
cp arch/arm/boot/dts/${ANTIX_DST} ${ANTIX_BOOT}
cd ~/antix/source
#rm -r linux-4.9.22
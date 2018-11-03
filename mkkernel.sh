#! /bin/bash
set -e
. env.sh
cd ${ANTIX_BASE}/source
test ! -d linux-4.9.22 && tar xvf linux-4.9.22.tar.xz 
cd linux-4.9.22
set +e
if [ "${ANTIX_BOARD}" = "npineo" ]; then
    patch -Np1 -i ../0029-ethernet-add-sun8i-emac-driver.patch
    patch -Np1 -i ../sun8i-h3-nanopi-neo.patch
    patch -Np1 -i ../sun8i-h3.patch
fi
set -e
#make mrproper
#wget https://raw.githubusercontent.com/lxsang/antix/master/nanopi-config-4.9.22
#mv nanopi-config-4.9.22 .config
#make ARCH=arm CROSS_COMPILE=${ANTIX_TARGET}- ${ANTIX_KERNEL_CONFIG}
#make ARCH=arm CROSS_COMPILE=${ANTIX_TARGET}- menuconfig
make -j 8 ARCH=arm CROSS_COMPILE=${ANTIX_TARGET}-
make ARCH=arm CROSS_COMPILE=${ANTIX_TARGET}- \
    INSTALL_MOD_PATH=${ANTIX_ROOT} modules_install
cp arch/arm/boot/zImage ${ANTIX_BOOT}
cp arch/arm/boot/dts/${ANTIX_DST} ${ANTIX_BOOT}
cd ${ANTIX_BASE}/source
#rm -r linux-4.9.22
# enable load module
# raspberry pi 8188eu:
# enable in Driver/staging
# enable CFG80211 wireless extension and rfkill in wireless support
# get firmware from https://github.com/lwfinger/rtl8188eu/raw/master/rtl8188eufw.bin and put in 
#  /lib/firmware/rtlwifi/
# to enable spi, use mode spi device should be enabled on SPI support

# For nanopineo
# enable sunxi8-emac driver in Driver/network driver/ethernet
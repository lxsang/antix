#! /bin/bash
set -e
. env.sh
. init.sh
cd ${ANTIX_BASE}/source
#test ! -d bcm2835-v4l2-driver && git clone https://github.com/lxsang/bcm2835-v4l2-driver
#test ! -d linux-4.9.22 && 
#cp -rvf ${ANTIX_BASE}/source/bcm2835-v4l2-driver/* drivers/staging/vc04_services
set +e
if [ "${ANTIX_BOARD}" = "npineo" ]; then
    tar xvf linux-4.9.22.tar.xz 
    cd linux-4.9.22
    patch -Np1 -i ../0029-ethernet-add-sun8i-emac-driver.patch
    patch -Np1 -i ../sun8i-h3-nanopi-neo.patch
    patch -Np1 -i ../sun8i-h3.patch
else
    #patch -Np1 -i ../rpiv1_spi.patch
    cd linux-4.14.y
fi
set -e
make mrproper
#wget https://raw.githubusercontent.com/lxsang/antix/master/nanopi-config-4.9.22
#mv nanopi-config-4.9.22 .config
make ARCH=arm CROSS_COMPILE=${ANTIX_TARGET}- ${ANTIX_KERNEL_CONFIG}
make ARCH=arm CROSS_COMPILE=${ANTIX_TARGET}- menuconfig
make -j 8 ARCH=arm CROSS_COMPILE=${ANTIX_TARGET}-
make ARCH=arm CROSS_COMPILE=${ANTIX_TARGET}- \
    INSTALL_MOD_PATH=${ANTIX_ROOT} modules_install
cp arch/arm/boot/dts/${ANTIX_DST} ${ANTIX_BOOT}
if [ "${ANTIX_BOARD}" = "npineo" ]; then
    cp arch/arm/boot/zImage ${ANTIX_BOOT}
else
    scripts/mkknlimg arch/arm/boot/zImage ${ANTIX_BOOT}/antix-kernel.img
    mkdir -p ${ANTIX_BOOT}/overlays
    cp -p arch/arm/boot/dts/overlays/*.dtb* ${ANTIX_BOOT}/overlays
    cd ${ANTIX_BOOT}
    wget https://github.com/raspberrypi/firmware/raw/master/boot/start.elf
    wget https://github.com/raspberrypi/firmware/raw/master/boot/start_x.elf
    wget https://github.com/raspberrypi/firmware/raw/master/boot/bootcode.bin
    wget https://github.com/raspberrypi/firmware/raw/master/boot/fixup.dat
    wget https://github.com/raspberrypi/firmware/raw/master/boot/fixup_x.dat
    cat > config.txt << "EOF"
enable_uart=1
#start_x=1             # essential
#gpu_mem=128           # at least, or maybe more if you wish
#disable_camera_led=1  # optional, if you don't want the led to glow
dtparam=spi=on
dtparam=i2c_arm=on
dtparam=i2c1=on
kernel=antix-kernel.img
EOF
    cat > cmdline.txt << "EOF"
dwc_otg.lpm_enable=0 console=ttyAMA0,115200 console=tty1 earlyprintk root=/dev/mmcblk0p2 rootfstype=ext4 rw rootwait panic=10
EOF
fi
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
#! /bin/bash
set -e
. env.sh
# sudo apt-get install device-tree-compiler
cd ${ANTIX_BASE}/source
if [ ! -d "u-boot" ]; then
    git clone git://git.denx.de/u-boot.git
fi
cd u-boot
git checkout v2016.11
make mrproper
make ARCH=arm CROSS_COMPILE=${ANTIX_TARGET}- ${ANTIX_UBOOT_CONFIG}
make -j 8 ARCH=arm CROSS_COMPILE=${ANTIX_TARGET}-
cp ${ANTIX_UBIN} ${ANTIX_BOOT}
if [ "${ANTIX_BOARD}" = "npineo" ]; then
    tty="S0"
    video=""
else
    tty="AMA0"
    video="video=HDMI-A-1:800x600@60D"
fi
cat > ${ANTIX_BOOT}/boot.cmd << "EOF"
# Nano pi neo
# fatload mmc 0 0x46000000 zImage
# fatload mmc 0 0x49000000  ${fdtfile}
# setenv bootargs console=ttyS0,115200 earlyprintk root=/dev/mmcblk0p2 rootfstype=ext4 rw rootwait panic=10 ${extra}
# bootz 0x46000000 - 0x49000000
fatload mmc 0 ${kernel_addr_r} zImage
fatload mmc 0 ${fdt_addr_r} ${fdtfile}
EOF
echo "setenv bootargs console=tty${tty},115200 earlyprintk ${video} root=/dev/mmcblk0p2 rootfstype=ext4 rw rootwait panic=10 \${extra}" >> ${ANTIX_BOOT}/boot.cmd
echo "bootz \${kernel_addr_r} - \${fdt_addr_r}" >> ${ANTIX_BOOT}/boot.cmd

mkimage -C none -A arm -T script -d ${ANTIX_BOOT}/boot.cmd ${ANTIX_BOOT}/boot.scr
# dd if=u-boot-sunxi-with-spl.bin of=/dev/sde bs=1024 seek=8
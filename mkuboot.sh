#! /bin/bash
set -e
. env.sh
# sudo apt-get install device-tree-compiler
cd ~/antix/source
git clone git://git.denx.de/u-boot.git
cd u-boot
git checkout v2016.11
make ARCH=arm CROSS_COMPILE=${ANTIX_TARGET}- ${ANTIX_UBOOT_CONFIG}
make -j 8 ARCH=arm CROSS_COMPILE=${ANTIX_TARGET}-
cp ${ANTIX_UBIN} ${ANTIX_BOOT}
cat > ${ANTIX_BOOT}/boot.cmd << "EOF"
# setenv bootm_boot_mode sec
# setenv fdt_high ffffffff
fatload mmc 0 0x46000000 zImage
fatload mmc 0 0x49000000  ${fdtfile}

setenv bootargs console=ttyS0,115200 earlyprintk root=/dev/mmcblk0p2 rootfstype=ext4 rw rootwait panic=10 ${extra}

bootz 0x46000000 - 0x49000000
EOF
mkimage -C none -A arm -T script -d ${ANTIX_BOOT}/boot.cmd ${ANTIX_BOOT}/boot.scr
# dd if=u-boot-sunxi-with-spl.bin of=/dev/sde bs=1024 seek=8
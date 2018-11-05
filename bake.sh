#! /bin/bash
set -e
test -f env.sh && rm env.sh
echo "#! /bin/bash" > env.sh
echo "Please select board:"
echo "  1. Nano pi neo"
echo "  2. Raspberry Pi V1 (Zero, A, A+, B, B+)"
read -p "selection (1):" board
case $board in
1)
    echo "export ANTIX_BOARD=npineo" >> env.sh
    echo "export ANTIX_ARCH=armv7-a" >> env.sh
    echo "export ANTIX_FLOAT=hard" >> env.sh
    echo "export ANTIX_FPU=vfp" >> env.sh
    echo "export ANTIX_DST=sun8i-h3-nanopi-neo.dtb" >> env.sh
    echo "export ANTIX_KERNEL_CONFIG=sunxi_defconfig" >> env.sh
    echo "export ANTIX_UBOOT_CONFIG=nanopi_neo_defconfig" >> env.sh
    echo "export ANTIX_UBIN=u-boot-sunxi-with-spl.bin" >> env.sh
    ;;
2)
    echo "export ANTIX_BOARD=rpi0" >> env.sh
    echo "export ANTIX_ARCH=armv6zk" >> env.sh
    echo "export ANTIX_FLOAT=hard" >> env.sh
    echo "export ANTIX_FPU=vfp" >> env.sh
    echo "export ANTIX_DST=bcm2*.dtb" >> env.sh
    echo "export ANTIX_KERNEL_CONFIG=bcmrpi_defconfig" >> env.sh #bcm2835_defconfig
    echo "export ANTIX_UBOOT_CONFIG=rpi_config" >> env.sh
    echo "export ANTIX_UBIN=u-boot.bin" >> env.sh
    ;;
*)
    echo "Invalid option"
    rm env.sh
    exit 0
    ;;
esac

echo "Please select LibC implementation:"
echo "  1. MUSL"
echo "  2. GLIBC"
read -p "selection (1):" libc

case $libc in
1)
    echo "export ANTIX_LIBC=musl" >> env.sh
    ;;
2)
    echo "export ANTIX_LIBC=gnu" >> env.sh
    ;;
*)
    echo "Invalid option"
    rm env.sh
    exit 0
    ;;
esac

echo "export ANTIX_BASE=~/antix-\${ANTIX_BOARD}-\${ANTIX_LIBC}" >> env.sh

echo "export ANTIX_ROOT=\${ANTIX_BASE}/rootfs/" >> env.sh
echo "export ANTIX_BOOT=\${ANTIX_BASE}/boot/"  >> env.sh
echo "export ANTIX_TOOLS=\${ANTIX_BASE}/cross-tools/"  >> env.sh
echo "export ANTIX_PKG_BUILD=\${ANTIX_BASE}/pkg-build/"  >> env.sh

echo "export ANTIX_TARGET=arm-linux-\${ANTIX_LIBC}eabihf" >> env.sh
echo "export ANTIX_HOST=\$(echo \${MACHTYPE} | sed 's/-[^-]*/-cross/')" >> env.sh
echo "export PATH=\${ANTIX_TOOLS}/bin:/bin:/usr/bin" >> env.sh

chmod +x env.sh

echo "Preparing.........."
./init.sh

echo "What do you want to do?:"
echo "  1. Build toolchain"
echo "  2. Buil kernel"
echo "  3. Build minimal root file system"
echo "  4. Build full root file system"
echo "  5. Build u-boot"
echo "  6. Build All"
echo "  7. Download all require sources"
read -p "selection (1):" act

case $act in
1)
    echo "Building the toolchain"
    ./mktoolchain.sh
    ;;
2)
    echo "Building the kernel"
    ./mkkernel.sh
    ;;
3)
    echo "Building minimal rootfs"
    ./mkrootfs-min.sh
    ;;
4)
    echo "Building full rootfs"
    ./mkrootfs.sh
    ;;
5)
    echo "Building U-Boot"
    ./mkuboot.sh
    ;;
6)
    echo "Building all"
    # build the toolchain
    ./mktoolchain.sh
    # build the minimal root fs with busybox
    ./mkrootfs.sh
    # build the kernel
    ./mkkernel.sh
    # build uboot for the board
    ./mkuboot.sh
    ;;
7)
    ./init.sh
    ;;
*)
    echo "Invalid option"
    rm env.sh
    exit 0
    ;;
esac
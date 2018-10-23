# antix
The build step is based on CLFS
This build is for nano pi neo

## Guide
```sh
# download everything needed
./init.sh
# build the toolchain
./mktoolchain.sh
# build the minimal root fs with busybox
./mkrootfs.sh
# build the kernel
./mkkernel.sh
# build uboot for the board
./mkuboot.sh

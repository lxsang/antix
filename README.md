# antix
The build step is based on CLFS
This build is for nano pi neo

## Set up
```sh
mkdir -p ~/antix/{source,rootfs,boot,cross-tools}
# now grab the source
cd ~/antix/source
wget http://ftp.gnu.org/gnu/binutils/binutils-2.27.tar.bz2
wget http://busybox.net/downloads/busybox-1.24.2.tar.bz2
wget http://sethwklein.net/iana-etc-2.30.tar.bz2
wget http://www.kernel.org/pub/linux/kernel/v4.x/linux-4.9.22.tar.xz
wget http://www.musl-libc.org/releases/musl-1.1.16.tar.gz
wget http://gcc.gnu.org/pub/gcc/releases/gcc-6.2.0/gcc-6.2.0.tar.bz2
wget http://ftp.gnu.org/gnu/gmp/gmp-6.1.1.tar.bz2
wget https://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz
wget http://ftp.gnu.org/gnu/mpfr/mpfr-3.1.4.tar.bz2
wget https://github.com/lxsang/antix/raw/master/bootscripts-embedded-HEAD.tar.gz
wget http://matt.ucc.asn.au/dropbear/releases/dropbear-2013.60.tar.bz2
wget http://www.red-bean.com/~bos/netplug/netplug-1.2.9.2.tar.bz2
wget http://downloads.sourceforge.net/libpng/zlib-1.2.8.tar.gz
wget --no-check-certificate http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.29.tar.gz
# patch
wget http://patches.clfs.org/embedded-dev/iana-etc-2.30-update-2.patch
wget http://patches.clfs.org/embedded-dev/netplug-1.2.9.2-fixes-1.patch
# export vars
export ANTIX_ROOT=~/antix/rootfs/
export ANTIX_BOOT=~/antix/boot/
export ANTIX_TOOLS=~/antix/cross-tools/
export ANTIX_TARGET=arm-linux-musleabihf
export ANTIX_ARCH=armv7-a
export ANTIX_FLOAT=hard
export ANTIX_FPU=vfp
export ANTIX_HOST=$(echo ${MACHTYPE} | sed "s/-[^-]*/-cross/")
PATH=${ANTIX_TOOLS}/bin:/bin:/usr/bin
mkdir -p ${ANTIX_TOOLS}/${ANTIX_TARGET}
```

## Building the tools chain
### linux header
```sh
tar xvf linux-4.9.22.tar.xz 
cd linux-4.9.22
make mrproper
make ARCH=arm headers_check
make ARCH=arm INSTALL_HDR_PATH=${ANTIX_TOOLS}/${ANTIX_TARGET} headers_install
```
### Binutils
```sh
cd ~/antix/source
tar xvf binutils-2.27.tar.bz2
cd binutils-2.27
mkdir -v ../binutils-build
cd ../binutils-build
../binutils-2.27/configure \
   --prefix=${ANTIX_TOOLS} \
   --target=${ANTIX_TARGET} \
   --with-sysroot=${ANTIX_TOOLS}/${ANTIX_TARGET} \
   --disable-nls \
   --disable-multilib
make configure-host
make
make install
cd ~/antix/source
rm -r binutils-build binutils-2.27
```
### Building GCC first pass
```sh
cd ~/antix/source
tar xvf gcc-6.2.0.tar.bz2
cd gcc-6.2.0
tar xf ../mpfr-3.1.4.tar.bz2
mv -v mpfr-3.1.4 mpfr
tar xf ../gmp-6.1.1.tar.bz2
mv -v gmp-6.1.1 gmp
tar xf ../mpc-1.0.3.tar.gz
mv -v mpc-1.0.3 mpc
mkdir -v ../gcc-build
cd ../gcc-build

../gcc-6.2.0/configure \
  --prefix=${ANTIX_TOOLS} \
  --build=${ANTIX_HOST} \
  --host=${ANTIX_HOST} \
  --target=${ANTIX_TARGET} \
  --with-sysroot=${ANTIX_TOOLS}/${ANTIX_TARGET} \
  --disable-nls \
  --disable-shared \
  --without-headers \
  --with-newlib \
  --disable-decimal-float \
  --disable-libgomp \
  --disable-libmudflap \
  --disable-libssp \
  --disable-libatomic \
  --disable-libquadmath \
  --disable-threads \
  --enable-languages=c \
  --disable-multilib \
  --with-mpfr-include=$(pwd)/../gcc-6.2.0/mpfr/src \
  --with-mpfr-lib=$(pwd)/mpfr/src/.libs \
  --with-arch=${ANTIX_ARCH} \
  --with-float=${ANTIX_FLOAT} \
  --with-fpu=${ANTIX_FPU}
 make all-gcc all-target-libgcc
 make install-gcc install-target-libgcc
 cd ~/antix/source
 rm -r gcc-6.2.0 gcc-build
```

### Musl
```sh
cd ~/antix/source
tar xvf musl-1.1.16.tar.gz 
cd musl-1.1.16/
./configure \
  CROSS_COMPILE=${ANTIX_TARGET}- \
  --prefix=/ \
  --target=${ANTIX_TARGET}
make
DESTDIR=${ANTIX_TOOLS}/${ANTIX_TARGET} make install
cd ~/antix/source
rm musl-1.1.16
```
### GCC second pass
```sh
cd ~/antix/source
tar xvf gcc-6.2.0.tar.bz2
cd gcc-6.2.0
tar xf ../mpfr-3.1.4.tar.bz2
mv -v mpfr-3.1.4 mpfr
tar xf ../gmp-6.1.1.tar.bz2
mv -v gmp-6.1.1 gmp
tar xf ../mpc-1.0.3.tar.gz
mv -v mpc-1.0.3 mpc
mkdir -v ../gcc-build
cd ../gcc-build
../gcc-6.2.0/configure \
  --prefix=${ANTIX_TOOLS} \
  --build=${ANTIX_HOST} \
  --host=${ANTIX_HOST} \
  --target=${ANTIX_TARGET} \
  --with-sysroot=${ANTIX_TOOLS}/${ANTIX_TARGET} \
  --disable-nls \
  --enable-languages=c \
  --enable-c99 \
  --enable-long-long \
  --disable-libmudflap \
  --disable-multilib \
  --with-mpfr-include=$(pwd)/../gcc-6.2.0/mpfr/src \
  --with-mpfr-lib=$(pwd)/mpfr/src/.libs \
  --with-arch=${ANTIX_ARCH} \
  --with-float=${ANTIX_FLOAT} \
  --with-fpu=${ANTIX_FPU}
 make
 make install
 cd ~/antix/source
 rm -r gcc-6.2.0 gcc-build
```

## Building minimal rootfs
### preparing
```sh
# create directories
mkdir -pv ${ANTIX_ROOT}/{bin,boot,dev,etc,home,lib/{firmware,modules}}
mkdir -pv ${ANTIX_ROOT}/{mnt,opt,proc,sbin,srv,sys}
mkdir -pv ${ANTIX_ROOT}/var/{cache,lib,local,lock,log,opt,run,spool}
install -dv -m 0750 ${ANTIX_ROOT}/root
install -dv -m 1777 ${ANTIX_ROOT}/{var/,}tmp
 mkdir -pv ${ANTIX_ROOT}/usr/{,local/}{bin,include,lib,sbin,share,src}
 #A proper Linux system maintains a list of the mounted file systems in the file /etc/mtab. With the way our embedded system is designed, we will be using a symlink to /proc/mounts: 
 ln -svf ../proc/mounts ${ANTIX_ROOT}/etc/mtab

# Create the /etc/passwd file by running the following command:
cat > ${ANTIX_ROOT}/etc/passwd << "EOF"
root::0:0:root:/root:/bin/ash
EOF

# Create the /etc/group file by running the following command: 
cat > ${ANTIX_ROOT}/etc/group << "EOF"
root:x:0:
bin:x:1:
sys:x:2:
kmem:x:3:
tty:x:4:
tape:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
EOF

touch ${ANTIX_ROOT}/var/log/lastlog
chmod -v 664 ${ANTIX_ROOT}/var/log/lastlog
```
### Install libgcc
```sh
cp -v ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libgcc_s.so.1 ${ANTIX_ROOT}/lib/
${ANTIX_TARGET}-strip ${ANTIX_ROOT}/lib/libgcc_s.so.1
```
### Install musl
```sh
cd ~/antix/source
tar xvf musl-1.1.16.tar.gz 
cd musl-1.1.16/
./configure \
  CROSS_COMPILE=${ANTIX_TARGET}- \
  --prefix=/ \
  --disable-static \
  --target=${ANTIX_TARGET}
 make -j 4
 DESTDIR=${ANTIX_ROOT} make install-libs
 cd ~/antix/source
 rm -r musl-1.1.16
```
### Install busybox
```sh
cd ~/antix/source
tar xvf busybox-1.24.2.tar.bz2
cd busybox-1.24.2
make distclean
make ARCH=arm defconfig
# we dont need the seds for glibc
sed -i 's/\(CONFIG_\)\(.*\)\(INETD\)\(.*\)=y/# \1\2\3\4 is not set/g' .config
sed -i 's/\(CONFIG_IFPLUGD\)=y/# \1 is not set/' .config
sed -i 's/\(CONFIG_FEATURE_WTMP\)=y/# \1 is not set/' .config
sed -i 's/\(CONFIG_FEATURE_UTMP\)=y/# \1 is not set/' .config
sed -i 's/\(CONFIG_UDPSVD\)=y/# \1 is not set/' .config
sed -i 's/\(CONFIG_TCPSVD\)=y/# \1 is not set/' .config
make -j 4 ARCH=arm CROSS_COMPILE="${ANTIX_TARGET}-"
make ARCH=arm CROSS_COMPILE="${ANTIX_TARGET}-"\
  CONFIG_PREFIX="${ANTIX_ROOT}" install
cp -v examples/depmod.pl ${ANTIX_TOOLS}/bin
chmod -v 755 ${ANTIX_TOOLS}/bin/depmod.pl
cd ~/antix/source
rm -r busybox-1.24.2
```
### Install Iana-Etc 
```sh
cd ~/antix/source
tar xvf iana-etc-2.30.tar.bz2
cd iana-etc-2.30
patch -Np1 -i ../iana-etc-2.30-update-2.patch
make get
make STRIP=yes
make DESTDIR=${ANTIX_ROOT} install
cd ~/antix/source
rm -r iana-etc-2.30
```
### Create a bootable system
```sh
cat > ${ANTIX_ROOT}/etc/fstab << "EOF"
# file-system  mount-point  type   options          dump  fsck
EOF
# bootscript
cd ~/antix/source
tar xvf bootscripts-embedded-HEAD.tar.gz
cd bootscripts-embedded
make DESTDIR=${ANTIX_ROOT} install-bootscripts
cd ~/antix/source
rm -r bootscripts-embedded

# mdev for busybox
cat > ${ANTIX_ROOT}/etc/mdev.conf<< "EOF"
# /etc/mdev/conf

# Devices:
# Syntax: %s %d:%d %s
# devices user:group mode

# null does already exist; therefore ownership has to be changed with command
null    root:root 0666  @chmod 666 $MDEV
zero    root:root 0666
grsec   root:root 0660
full    root:root 0666

random  root:root 0666
urandom root:root 0444
hwrandom root:root 0660

# console does already exist; therefore ownership has to be changed with command
#console        root:tty 0600   @chmod 600 $MDEV && mkdir -p vc && ln -sf ../$MDEV vc/0
console root:tty 0600 @mkdir -pm 755 fd && cd fd && for x in 0 1 2 3 ; do ln -sf /proc/self/fd/$x $x; done

fd0     root:floppy 0660
kmem    root:root 0640
mem     root:root 0640
port    root:root 0640
ptmx    root:tty 0666

# ram.*
ram([0-9]*)     root:disk 0660 >rd/%1
loop([0-9]+)    root:disk 0660 >loop/%1
sd[a-z].*       root:disk 0660 */lib/mdev/usbdisk_link
hd[a-z][0-9]*   root:disk 0660 */lib/mdev/ide_links
md[0-9]         root:disk 0660

tty             root:tty 0666
tty[0-9]        root:root 0600
tty[0-9][0-9]   root:tty 0660
ttyS[0-9]*      root:tty 0660
pty.*           root:tty 0660
vcs[0-9]*       root:tty 0660
vcsa[0-9]*      root:tty 0660

ttyLTM[0-9]     root:dialout 0660 @ln -sf $MDEV modem
ttySHSF[0-9]    root:dialout 0660 @ln -sf $MDEV modem
slamr           root:dialout 0660 @ln -sf $MDEV slamr0
slusb           root:dialout 0660 @ln -sf $MDEV slusb0
fuse            root:root  0666

# dri device
card[0-9]       root:video 0660 =dri/

# alsa sound devices and audio stuff
pcm.*           root:audio 0660 =snd/
control.*       root:audio 0660 =snd/
midi.*          root:audio 0660 =snd/
seq             root:audio 0660 =snd/
timer           root:audio 0660 =snd/

adsp            root:audio 0660 >sound/
audio           root:audio 0660 >sound/
dsp             root:audio 0660 >sound/
mixer           root:audio 0660 >sound/
sequencer.*     root:audio 0660 >sound/

# misc stuff
agpgart         root:root 0660  >misc/
psaux           root:root 0660  >misc/
rtc             root:root 0664  >misc/

# input stuff
event[0-9]+     root:root 0640 =input/
mice            root:root 0640 =input/
mouse[0-9]      root:root 0640 =input/
ts[0-9]         root:root 0600 =input/

# v4l stuff
vbi[0-9]        root:video 0660 >v4l/
video[0-9]      root:video 0660 >v4l/

# dvb stuff
dvb.*           root:video 0660 */lib/mdev/dvbdev

# load drivers for usb devices
usbdev[0-9].[0-9]       root:root 0660 */lib/mdev/usbdev
usbdev[0-9].[0-9]_.*    root:root 0660

# net devices
tun[0-9]*       root:root 0600 =net/
tap[0-9]*       root:root 0600 =net/

# zaptel devices
zap(.*)         root:dialout 0660 =zap/%1
dahdi!(.*)      root:dialout 0660 =dahdi/%1

# raid controllers
cciss!(.*)      root:disk 0660 =cciss/%1
ida!(.*)        root:disk 0660 =ida/%1
rd!(.*)         root:disk 0660 =rd/%1

sr[0-9]         root:cdrom 0660 @ln -sf $MDEV cdrom 

# hpilo
hpilo!(.*)      root:root 0660 =hpilo/%1

# xen stuff
xvd[a-z]        root:root 0660 */lib/mdev/xvd_links
EOF

cat > ${ANTIX_ROOT}/etc/profile << "EOF"
# /etc/profile

# Set the initial path
export PATH=/bin:/usr/bin

if [ `id -u` -eq 0 ] ; then
        PATH=/bin:/sbin:/usr/bin:/usr/sbin
        unset HISTFILE
fi

# Setup some environment variables.
export USER=`id -un`
export LOGNAME=$USER
export HOSTNAME=`/bin/hostname`
export HISTSIZE=1000
export HISTFILESIZE=1000
export PAGER='/bin/more '
export EDITOR='/bin/vi'

# End /etc/profile
EOF

cat > ${ANTIX_ROOT}/etc/inittab<< "EOF"
# /etc/inittab

::sysinit:/etc/rc.d/startup

tty1::respawn:/sbin/getty 38400 tty1
tty2::respawn:/sbin/getty 38400 tty2
tty3::respawn:/sbin/getty 38400 tty3
tty4::respawn:/sbin/getty 38400 tty4
tty5::respawn:/sbin/getty 38400 tty5
tty6::respawn:/sbin/getty 38400 tty6

# Put a getty on the serial line (for a terminal).  Uncomment this line if
# you're using a serial console on ttyS0, or uncomment and adjust it if using a
# serial console on a different serial port.
::respawn:/sbin/getty -L ttyS0 115200 vt100

::shutdown:/etc/rc.d/shutdown
::ctrlaltdel:/sbin/reboot
EOF

echo "Antix" > ${ANTIX_ROOT}/etc/HOSTNAME

cat > ${ANTIX_ROOT}/etc/hosts << "EOF"
# Begin /etc/hosts (network card version)
127.0.0.1 localhost
# End /etc/hosts (network card version)
EOF
```
### Network
```sh
mkdir -pv ${ANTIX_ROOT}/etc/network/if-{post-{up,down},pre-{up,down},up,down}.d
mkdir -pv ${ANTIX_ROOT}/usr/share/udhcpc

cat > ${ANTIX_ROOT}/etc/network/interfaces << "EOF"
auto eth0
iface eth0 inet dhcp
EOF
cat > ${ANTIX_ROOT}/usr/share/udhcpc/default.script << "EOF"
#!/bin/sh
# udhcpc Interface Configuration
# Based on http://lists.debian.org/debian-boot/2002/11/msg00500.html
# udhcpc script edited by Tim Riker <Tim@Rikers.org>

[ -z "$1" ] && echo "Error: should be called from udhcpc" && exit 1

RESOLV_CONF="/etc/resolv.conf"
[ -n "$broadcast" ] && BROADCAST="broadcast $broadcast"
[ -n "$subnet" ] && NETMASK="netmask $subnet"

case "$1" in
        deconfig)
                /sbin/ifconfig $interface 0.0.0.0
                ;;

        renew|bound)
                /sbin/ifconfig $interface $ip $BROADCAST $NETMASK

                if [ -n "$router" ] ; then
                        while route del default gw 0.0.0.0 dev $interface ; do
                                true
                        done

                        for i in $router ; do
                                route add default gw $i dev $interface
                        done
                fi

                echo -n > $RESOLV_CONF
                [ -n "$domain" ] && echo search $domain >> $RESOLV_CONF
                for i in $dns ; do
                        echo nameserver $i >> $RESOLV_CONF
                done
                ;;
esac

exit 0
EOF

chmod +x ${ANTIX_ROOT}/usr/share/udhcpc/default.script
```

#! /bin/bash
#test -f Makefile && make reallyclean
set -e
. ../env.sh
. ../toolchain.sh
cd ~/antix/source
if [ ! -d "opensmalltalk-vm" ]; then
    # download it
   git clone https://github.com/OpenSmalltalk/opensmalltalk-vm
   cd opensmalltalk-vm
else
    cd opensmalltalk-vm
    git stash
fi
if [ ! -f "sm_vm_musl.patch" ]; then
    wget https://github.com/lxsang/antix/raw/master/sm_vm_musl.patch
fi
patch -Np1 -i sm_vm_musl.patch

mkdir ../build.armv7.squeak.stack
cd ../build.armv7.squeak.stack
echo "EXTERNAL_PLUGINS = \\" > plugins.ext 
echo "INTERNAL_PLUGINS = \\" > plugins.int

../opensmalltalk-vm/platforms/unix/config/configure \
    --without-x \
    --without-gl \
    --without-vm-display-fbdev\
    --without-vm-sound-OSS\
    --with-src=spurstacksrc \
    --without-npsqueak  \
    --with-vmversion=5.0 \
    --disable-cogit\
    CFLAGS="-fPIC -DNO_VM_PROFILE -DI_REALLY_DONT_CARE_HOW_UNSAFE_THIS_IS -DCOGMTVM=0"
    #\
    #--build=${ANTIX_HOST} \
    #--host=${ANTIX_TARGET}
    # --with-vmversion=5.0 \
#    --target=${ANTIX_TARGET}\
make -j8 install-squeak install-plugins prefix=${ANTIX_PKG_BUILD}/smalltalk  
cd ~/antix/source
rm -r build.armv7.squeak.stack
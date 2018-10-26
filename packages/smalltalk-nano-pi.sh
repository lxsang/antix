#! /bin/bash
#test -f Makefile && make reallyclean
set -e
. ../env.sh
. ../toolchain.sh
if [ ! -d "opensmalltalk-vm" ]; then
    # download it
   git clone https://github.com/OpenSmalltalk/opensmalltalk-vm
   cd opensmalltalk-vm
else
    cd opensmalltalk-vm
    git stash
fi

test -d "build.armv7.squeak.stack" && rm -r "build.armv7.squeak.stack"
mkdir "build.armv7.squeak.stack"

echo "EXTERNAL_PLUGINS = \\" > plugins.ext 
echo "INTERNAL_PLUGINS = \\" > plugins.int
test -f plugins.int || (test -f ../plugins.int && cp -p ../plugins.int . || cp -p ../../plugins.int .)
test -f plugins.ext || (test -f ../plugins.ext && cp -p ../plugins.ext . || cp -p ../../plugins.ext .)
# patch the vm 
p=`pwd`  
cd ../../..
git stash
patch -Np1 -i $p/cog_vm_musl.patch
cd $p
../../../platforms/unix/config/configure \
    --without-x \
    --without-gl \
    --without-vm-display-fbdev\
    --without-vm-sound-OSS\
    --with-src=spurstacksrc \
    --without-npsqueak  \
    --disable-cogit\
    CFLAGS="-std=c99 -fPIC -DNO_VM_PROFILE -DI_REALLY_DONT_CARE_HOW_UNSAFE_THIS_IS -DCOGMTVM=0"
    #\
    #--build=${ANTIX_HOST} \
    #--host=${ANTIX_TARGET}
    # --with-vmversion=5.0 \
#    --target=${ANTIX_TARGET}\
make -j8 install-squeak install-plugins prefix=${ANTIX_PKG_BUILD}/smalltalk  
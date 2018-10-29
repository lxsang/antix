#! /bin/bash
#test -f Makefile && make reallyclean
set -e
. ../env.sh
#. ../toolchain.sh
cd ${ANTIX_BASE}/source
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
if [ "$ANTIX_LIBC" = "musl" ]; then
    patch -Np1 -i sm_vm_musl.patch
fi
if [ -d ../build.armv.squeak.stack ]; then
    rm -r ../build.armv.squeak.stack
fi
mkdir ../build.armv.squeak.stack
cd ../build.armv.squeak.stack
cat > plugins.int << "EOF"
INTERNAL_PLUGINS = \
FilePlugin \
SocketPlugin
EOF
cat > plugins.ext << "EOF"
"EXTERNAL_PLUGINS = \"
EOF
../opensmalltalk-vm/platforms/unix/config/configure \
    --without-x \
    --without-gl \
    --without-vm-display-fbdev\
    --without-vm-sound-OSS\
    --with-src=spurstacksrc \
    --without-npsqueak  \
    --with-vmversion=5.0 \
    --host=${ANTIX_TARGET} \
    --disable-cogit\
    CFLAGS="-fPIC  -DDEBUGVM=1 -DCOGMTVM=0" # -DNO_VM_PROFILE
    #\
    #--build=${ANTIX_HOST} \
    #--host=${ANTIX_TARGET}
    # --with-vmversion=5.0 \
#    --target=${ANTIX_TARGET}\
make -j8 install-squeak install-plugins prefix=${ANTIX_PKG_BUILD}/smalltalk  
cd ${ANTIX_BASE}/source
# create .*so file
# display
cd ${ANTIX_PKG_BUILD}/smalltalk/lib/squeak/5.0-/
${ANTIX_TARGET}-ar -x libvm-display-null.a
${ANTIX_TARGET}-gcc -shared ./*.o -o libvm-display-null.so
rm *.o
# sound
${ANTIX_TARGET}-ar -x libvm-sound-null.a
${ANTIX_TARGET}-gcc -shared *.o -o libvm-sound-null.so
rm *.o
cd ${ANTIX_BASE}/source
rm -r build.armv.squeak.stack
# install to rootfs
mkdir -p ${ANTIX_ROOT}/opt/smalltalk
cp -v ${ANTIX_PKG_BUILD}/smalltalk/lib/squeak/5.0-/squeak ${ANTIX_ROOT}/opt/smalltalk
cp -v ${ANTIX_PKG_BUILD}/smalltalk/lib/squeak/5.0-/*.so ${ANTIX_ROOT}/opt/smalltalk

cat > ${ANTIX_ROOT}/usr/bin/pharo << "EOF"
#! /bin/ash
/opt/smalltalk/squeak -plugins /opt/smalltalk -vm-display-null "$@"
EOF

chmod +x ${ANTIX_ROOT}/usr/bin/pharo
# now cpoy the image
if [ ! -f "50496.zip" ]; then
    wget https://files.pharo.org/image/50/50496.zip
fi
unzip 50496.zip -d ${ANTIX_ROOT}/opt/smalltalk
rm -rf ${ANTIX_PKG_BUILD}/smalltalk

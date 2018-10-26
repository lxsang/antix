#! /bin/bash
# This script should be run as sudo
# otherwise the build will fail
set -e
. ../env.sh
cd ~/antix-${ANTIX_BOARD}/source
if [ ! -f "sudo-1.8.25.tar.gz" ]; then
    # download it
    wget https://www.sudo.ws/dist/sudo-1.8.25.tar.gz
fi
tar xvf sudo-1.8.25.tar.gz
cd sudo-1.8.25

set +e
ln -s ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libc.so /lib/ld-musl-armhf.so.1
set -e

./configure --build= \
    --host=${ANTIX_TARGET}\
    --prefix=/usr \
    --with-secure-path  \
    --with-all-insults  \
    --without-linux-audit \
    --without-pam \
    --libexecdir=/usr/lib \
    --with-passprompt="[sudo] password for %p: "
    #--with-libpath=${ANTIX_ROOT}/lib\
LD=${ANTIX_TARGET}-ld NM="${ANTIX_TARGET}-nm -p" make -j 8
make DESTDIR=${ANTIX_PKG_BUILD}/sudo install
rm -r ${ANTIX_PKG_BUILD}/sudo/usr/share
cp -rf ${ANTIX_PKG_BUILD}/sudo/* ${ANTIX_ROOT}
if [ ! -L "${ANTIX_ROOT}/usr/bin/vi" ]; then
    ln -s /bin/vi ${ANTIX_ROOT}/usr/bin/vi
fi
sed -i -E 's/\# \%sudo/\%sudo/' ${ANTIX_ROOT}/etc/sudoers
chown root:root ${ANTIX_ROOT}/usr/bin/sudo
chmod u+s ${ANTIX_ROOT}/usr/bin/sudo
chmod 4755 ${ANTIX_ROOT}/usr/bin/sudo
cd ~/antix-${ANTIX_BOARD}/source
rm -rf sudo-1.8.25 ${ANTIX_PKG_BUILD}/sudo
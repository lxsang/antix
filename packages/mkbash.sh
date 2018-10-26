#! /bin/bash
set -e
. ../env.sh
cd ~/antix/source
if [ ! -f "bash-4.4.tar.gz" ]; then
    # download it
    wget http://ftp.gnu.org/gnu/bash/bash-4.4.tar.gz
fi
tar xvf bash-4.4.tar.gz
cd bash-4.4
echo "bash_cv_sys_named_pipes=yes" > config.cache
./configure --build=${ANTIX_HOST} --host=${ANTIX_TARGET} \
    --prefix=/usr --bindir=/bin --cache-file=config.cache \
    --without-bash-malloc \
    --without-manpages \
    --with-installed-readline
make -j 8
make DESTDIR=${ANTIX_PKG_BUILD}/bash install
cp -v -rf ${ANTIX_PKG_BUILD}/bash/bin/* ${ANTIX_ROOT}/bin/
cp -v -rf ${ANTIX_PKG_BUILD}/bash/usr/lib/* ${ANTIX_ROOT}/usr/lib
# cp -v -rf ${ANTIX_PKG_BUILD}/bash/usr/share/locale ${ANTIX_ROOT}/usr/share/
cd ~/antix/source
rm -rf bash-4.4 ${ANTIX_PKG_BUILD}/bash
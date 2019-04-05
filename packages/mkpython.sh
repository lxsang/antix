#! /bin/bash
# host: sudo apt-get install python-dev
# require libffi for ctype to work
set -e
. ../env.sh
NAME="Python"
VERSION="3.7.3"
BASENAME=${NAME}-${VERSION}
BPWD=`pwd`
cd ${ANTIX_BASE}/source
if [ ! -f "$BASENAME.tar.xz" ]; then
    # download it
    wget  https://www.python.org/ftp/python/$VERSION/$BASENAME.tar.xz
fi
sudo rm -rf $BASENAME $BASENAME-host
# build of PGEM first

tar xvf $BASENAME.tar.xz
mv $BASENAME $BASENAME-host
cd $BASENAME-host
./configure
make -j 8 python Parser/pgen
# python 3.7 should be already installed on the system
# sudo make -j 8 install
#test ! -L /usr/bin/python3.7 && sudo ln -s /usr/local/bin/python3.7 /usr/bin/python3.7

# now change the environment
cd $BPWD
. ../toolchain.sh
cd ${ANTIX_BASE}/source
# cross compile python
tar xvf $BASENAME.tar.xz
cd $BASENAME
./configure \
    --host=${ANTIX_TARGET} \
    --target=${ANTIX_TARGET} \
    --build=${ANTIX_HOST} \
    --prefix=/usr \
    --disable-ipv6 \
    ac_cv_file__dev_ptmx=no \
    ac_cv_file__dev_ptc=no \
    ac_cv_have_long_long_format=yes \
    --enable-shared

# make it
DESTDIR=${ANTIX_TOOLS}/${ANTIX_TARGET} make -j 8\
    HOSTPYTHON=../$BASENAME-host/python \
    HOSTPGEN=../$BASENAME-host/Parser/pgen \
    BLDSHARED="${CC} -shared" \
    CROSS-COMPILE=${ANTIX_TARGET}- \
    CROSS_COMPILE_TARGET=yes HOSTARCH=arm-linux \
    BUILDARCH=${ANTIX_TARGET}
DESTDIR=${ANTIX_TOOLS}/${ANTIX_TARGET} make -j 8 install

while true; do
    read -p "Do you wish to install python to root fs?" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit 0;;
        * ) echo "Please answer yes or no.";;
    esac
done

# install binaries to root fs
cp -av ${ANTIX_TOOLS}/${ANTIX_TARGET}/bin/{python3,python3.7,python3.7m} ${ANTIX_ROOT}/usr/bin/
cp -arfv ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/{python3.7,libpython3.7m.so,libpython3.7m.so.1.0,libpython3.so} ${ANTIX_ROOT}/usr/lib/

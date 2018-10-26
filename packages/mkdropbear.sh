#! /bin/bash
set -e
. ../env.sh
. ../toolchain.sh
echo ${CC}

cd ~/antix/source
if [ ! -f "dropbear-2018.76.tar.bz2" ]; then
    # download it
    wget https://matt.ucc.asn.au/dropbear/dropbear-2018.76.tar.bz2
fi
tar xvf dropbear-2018.76.tar.bz2
cd dropbear-2018.76
sed -i 's/.*mandir.*//g' Makefile.in
CC="${CC} -Os" ./configure --prefix=/usr --host=${ANTIX_TARGET}
make -j 8 MULTI=1 \
  PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp"

make MULTI=1 \
  PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" \
  install DESTDIR=${ANTIX_ROOT}
install -dv ${ANTIX_ROOT}/etc/dropbear
# make boot script
cd ~/antix/source
tar xvf bootscripts-embedded-HEAD.tar.gz
cd bootscripts-embedded
make DESTDIR=${ANTIX_ROOT} install-dropbear
cd ~/antix/source
rm -r bootscripts-embedded
cd ~/antix/source
rm -rf dropbear-2018.76
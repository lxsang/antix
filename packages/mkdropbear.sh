#! /bin/bash
set -e
. ../env.sh
. ../toolchain.sh
echo ${CC}

cd ${ANTIX_BASE}/source
if [ ! -f "dropbear-2017.75.tar.bz2" ]; then
    # download it
    wget https://matt.ucc.asn.au/dropbear/releases/dropbear-2017.75.tar.bz2
    #https://matt.ucc.asn.au/dropbear/dropbear-2017.75.tar.bz2 
    # the 2018 version does not work proprely on raspberry pi zeo
    # so we just get the older verion 2017.75
    #https://matt.ucc.asn.au/dropbear/dropbear-2018.76.tar.bz2
fi

tar xvf dropbear-2017.75.tar.bz2
cd dropbear-2017.75
sed -i 's/.*mandir.*//g' Makefile.in
CC="${CC} -Os" ./configure --prefix=/usr --host=${ANTIX_TARGET} 
#--disable-zlib
make -j 8 MULTI=1 \
  PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp"

make MULTI=1 \
  PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" \
  install DESTDIR=${ANTIX_ROOT}
install -dv ${ANTIX_ROOT}/etc/dropbear
# make boot script
cd ${ANTIX_BASE}/source
tar xvf bootscripts-embedded-HEAD.tar.gz
cd bootscripts-embedded
make DESTDIR=${ANTIX_ROOT} install-dropbear
cd ${ANTIX_BASE}/source
rm -r bootscripts-embedded
cd ${ANTIX_BASE}/source
rm -rf dropbear-2017.75

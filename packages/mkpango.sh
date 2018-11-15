#! /bin/bash
# depend on
# - freetype
# -fontconfig
# -harfbuzz
# -fribidi
# -glib 2.0
set -e
. ../env.sh
. ../toolchain.sh
dir="pango-1.42.4"
cd ${ANTIX_BASE}/source
if [ ! -f "${dir}.tar.xz" ]; then
    # download it
    wget http://ftp.gnome.org/pub/GNOME/sources/pango/1.42/pango-1.42.4.tar.xz
fi
tar xvf ${dir}.tar.xz
cd ${dir}
# configure cross platform
./configure --prefix=${ANTIX_PKG_BUILD}/pango\
    --build=${ANTIX_HOST}\
    --host=${ANTIX_TARGET}\
    --without-cairo \
    --without-x
   
make -j8
make install

#cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libharfbuzz*.so* ${ANTIX_ROOT}/usr/lib

cd ${ANTIX_BASE}/source
rm -rf  ${dir}
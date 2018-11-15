#! /bin/bash
# depend on:
# - libpng12
# - harfbuzz
set -e
. ../env.sh

cd ${ANTIX_BASE}/source
if [ ! -f "freetype-2.7.tar.gz" ]; then
    # download it
    wget https://download.savannah.gnu.org/releases/freetype/freetype-2.7.tar.gz
fi
tar xvf freetype-2.7.tar.gz
cd freetype-2.7
# configure cross platform
# first compile freetype wo harfbuzz
# then compile harfbuzz with freetype
# then compile freetype with harfbuzz
./configure --prefix=${ANTIX_TOOLS}/${ANTIX_TARGET}\
    --build=${ANTIX_HOST} \
    --host=${ANTIX_TARGET} \
    --with-harfbuzz=yes
make -j8
make install
#sed -i -E "s%${ANTIX_PKG_BUILD}/freetype/usr/local%${ANTIX_TOOLS}/${ANTIX_TARGET}%"  ${ANTIX_PKG_BUILD}/freetype/usr/local/bin/freetype-config
#cp -avrf ${ANTIX_PKG_BUILD}/freetype/usr/local/* ${ANTIX_TOOLS}/${ANTIX_TARGET}/
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libfreetype.so* ${ANTIX_ROOT}/usr/lib
#cp -avrf ${ANTIX_PKG_BUILD}/freetype/usr/local/bin/freetype-config ${ANTIX_ROOT}/usr/bin
cd ${ANTIX_BASE}/source
rm -rf freetype-2.7
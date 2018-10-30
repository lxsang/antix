#! /bin/bash
set -e
. ../env.sh
. ../toolchain.sh
cd ${ANTIX_BASE}/source
if [ ! -d "apk-tools" ]; then
    # download it
    git clone https://github.com/lxsang/apk-tools
    cd apk-tools
else
    cd apk-tools
    #git stash
fi
git checkout 2.8-stable
make clean
make -j 8 LUAAPK= DESTDIR=${ANTIX_PKG_BUILD}/apk CROSS_COMPILE="${ANTIX_TARGET}-"  CFLAGS="-Wno-unused-result" static
make LUAAPK= CROSS_COMPILE="${ANTIX_TARGET}-" DESTDIR=${ANTIX_PKG_BUILD}/apk install
#mkdir -pv ${ANTIX_ROOT}/opt/www/{htdocs,database,tmp}
#cp config.ini.tpl ${ANTIX_ROOT}/opt/www/config.ini
#chmod u+x ${ANTIX_ROOT}/opt/www/antd
#cd ${ANTIX_BASE}/source
#rm -rf ant-http
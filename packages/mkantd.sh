#! /bin/bash
set -e
. ../env.sh
cd ~/antix-${ANTIX_BOARD}/source
if [ ! -d "ant-http" ]; then
    # download it
    git clone https://github.com/lxsang/ant-http
    cd ant-http
else
    cd ant-http
    git stash
fi
if [ -d "plugins" ]; then
    cd plugins
    rm -rf ./*
else
    mkdir plugins
    cd plugins
fi
git clone "https://github.com/lxsang/antd-lua-plugin"
git clone "https://github.com/lxsang/antd-wterm-plugin"
git clone "https://github.com/lxsang/antd-cgi-plugin"
sed  -i -E "s/CC= gcc/CC=${ANTIX_TARGET}-gcc/" antd-lua-plugin/3rd/lua-5.3.4/Makefile
sed -i -E "s/ann.llib stmr.llib//" antd-lua-plugin/Makefile
cd ../
escape="${ANTIX_ROOT//\//\\/}"
escape="${escape//\./\\.}"
escape="${escape//\-/\\-}"
cmd="sed -i -E 's/[^P]BUILDIRD=.*/BUILDIRD=${escape}\/opt\/www/' var.mk"
eval $cmd
cmd="sed -i -E 's/CC=gcc/CC=${ANTIX_TARGET}-gcc/' var.mk"
eval $cmd
sed -i -E 's/ENGINE\_cleanup/\/\/ENGINE\_cleanup/' httpd.c
sed -i -E 's/FIPS\_mode\_set/\/\/FIPS\_mode\_set/' httpd.c

make -j 8
mkdir -pv ${ANTIX_ROOT}/opt/www/{htdocs,database,tmp}
cp config.ini.tpl ${ANTIX_ROOT}/opt/www/config.ini
chmod u+x ${ANTIX_ROOT}/opt/www/antd
cd ~/antix-${ANTIX_BOARD}/source
rm -rf ant-http
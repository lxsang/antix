
#! /bin/bash

set -e
. ../env.sh
. ../toolchain.sh

dir="antd-1.0.4b"
cd ${ANTIX_BASE}/source
if [ ! -f "${dir}.tar.gz" ]; then
    # download it
    wget https://github.com/lxsang/ant-http/raw/master/dist/${dir}.tar.gz
fi
tar xvf ${dir}.tar.gz
cd ${dir}

#patch the code
sed -i '/FIPS_mode_set(0);/d' httpd.c 
# configure cross platform 
./configure --prefix=${ANTIX_TOOLS}/${ANTIX_TARGET}/ \
    --build=${ANTIX_HOST}\
    --host=${ANTIX_TARGET}


make -j8
make install



cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}//lib/libantd.so* ${ANTIX_ROOT}/usr/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}//bin/antd ${ANTIX_ROOT}/usr/bin
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}//etc/antd-config.ini ${ANTIX_ROOT}/etc/

cd ${ANTIX_BASE}/source
rm -rf  ${dir}



# wterm
# install lua plugin
dir="wterm-1.0.0b"
cd ${ANTIX_BASE}/source
if [ ! -f "${dir}.tar.gz" ]; then
    # download it

    wget https://github.com/lxsang/antd-wterm-plugin/raw/master/dist/${dir}.tar.gz
fi
tar xvf ${dir}.tar.gz
cd ${dir}

# configure cross platform 
./configure --prefix=${ANTIX_ROOT}/opt/www \
    --build=${ANTIX_HOST}\
    --host=${ANTIX_TARGET}


make -j8
make install

cd ${ANTIX_BASE}/source
rm -rf  ${dir}


# wterm
# install lua plugin
dir="cgi-1.0.0b"
cd ${ANTIX_BASE}/source
if [ ! -f "${dir}.tar.gz" ]; then
    # download it

    wget https://github.com/lxsang/antd-cgi-plugin/raw/master/dist/${dir}.tar.gz
fi
tar xvf ${dir}.tar.gz
cd ${dir}

# configure cross platform 
./configure --prefix=${ANTIX_ROOT}/opt/www \
    --build=${ANTIX_HOST}\
    --host=${ANTIX_TARGET}


make -j8
make install

cd ${ANTIX_BASE}/source
rm -rf  ${dir}


# install lua plugin
dir="lua-0.5.2b"
cd ${ANTIX_BASE}/source
if [ ! -f "${dir}.tar.gz" ]; then
    # download it

    wget https://github.com/lxsang/antd-lua-plugin/raw/master/dist/${dir}.tar.gz
fi
tar xvf ${dir}.tar.gz
cd ${dir}
sed  -i -E "s/CC= gcc/CC=${ANTIX_TARGET}-gcc/" 3rd/lua-5.3.4/Makefile
sed  -i -E "s/ann//" lib/Makefile.am
#patch the code
# configure cross platform 
./configure --prefix=${ANTIX_ROOT}/opt/www \
    --build=${ANTIX_HOST}\
    --host=${ANTIX_TARGET}


make -j8
make install

cd ${ANTIX_BASE}/source
rm -rf  ${dir}

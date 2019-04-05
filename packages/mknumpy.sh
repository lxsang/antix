#! /bin/bash 
# build numpy library for python3.7
# require the python3.7 packages to
# be available
# require to install cython on the 
# build system
# python3.7 -m pip install Cython
# python3.7 should be installed on build system
set -e
. ../env.sh
. ../toolchain.sh
cd ${ANTIX_BASE}/source

if [ ! -d "numpy" ]; then
    # download it
    git clone https://github.com/numpy/numpy
fi

cd numpy
# trick the build system to use
# the cross compiler & linker
ARCH=$(echo ${MACHTYPE} | sed 's/-.*//')
test ! -L ${ANTIX_TOOLS}/bin/ld && ln -s ${ANTIX_TOOLS}/bin/${ANTIX_TARGET}-ld ${ANTIX_TOOLS}/bin/ld
test ! -L ${ANTIX_TOOLS}/bin/gcc && ln -s ${ANTIX_TOOLS}/bin/${ANTIX_TARGET}-gcc ${ANTIX_TOOLS}/bin/gcc
test ! -L ${ANTIX_TOOLS}/bin/${ARCH}-linux-gnu-gcc && ln -s ${ANTIX_TOOLS}/bin/${ANTIX_TARGET}-gcc ${ANTIX_TOOLS}/bin/${ARCH}-linux-gnu-gcc
git clean -xdf
mkdir -p ${ANTIX_PKG_BUILD}/numpy/lib/python3.7/site-packages
BLAS=None \
LAPACK=None \
ATLAS=None \
CC=gcc \
PYTHONPATH="${ANTIX_PKG_BUILD}/numpy/lib/python3.7/site-packages:${PYTHONPATH}" \
CFLAGS="-std=c99 -I${ANTIX_TOOLS}/${ANTIX_TARGET}/include/python3.7m" \
LDFLAGS="-L${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/" \
python3.7 setup.py build -j 8 install --prefix ${ANTIX_PKG_BUILD}/numpy
# now copy everything to toolchain & rootfs
cp -arfv ${ANTIX_PKG_BUILD}/numpy/lib/python3.7/site-packages/* \
    ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/python3.7/site-packages/
# copy some missing packages
# pkg_resources
cp -avrf /usr/lib/python3/dist-packages/pkg_resources \
     ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/python3.7/site-packages
# remove the fake compiler and linker :)
rm -rf ${ANTIX_TOOLS}/bin/ld ${ANTIX_TOOLS}/bin/gcc ${ANTIX_TOOLS}/bin/${ARCH}-linux-gnu-gcc

while true; do
    read -p "Do you wish to install numpy to root fs?" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit 0;;
        * ) echo "Please answer yes or no.";;
    esac
done
cp -arfv ${ANTIX_PKG_BUILD}/numpy/lib/python3.7/site-packages/* \
    ${ANTIX_ROOT}/usr/lib/python3.7/site-packages/
cp -avrf /usr/lib/python3/dist-packages/pkg_resources \
    ${ANTIX_ROOT}/usr/lib/python3.7/site-packages/
#! /bin/bash
# build dep: sudo apt-get build-dep opencv
# this make is tested for raspberry pi toolchain
# should work on nano pi toolchain with
# some minor changes eg: neon or vfpv3 options
# this will install openCV libraries to the
# toolchain, other openCV based application
# should copy the used libraries from the
# toolchain along with the application binary to
# the root file system
# this build require python3 package, see mkpython.sh
# make sure the build system use python3.7
set -e
. ../env.sh
. ../toolchain.sh
cd ${ANTIX_BASE}/source
VERSION="3.4"
if [ ! -d "opencv" ]; then
    # download it
    git clone https://github.com/opencv/opencv
fi
cd opencv
git checkout $VERSION
cd ../
if [ ! -d "opencv_contrib" ]; then
    # download it
    git clone https://github.com/opencv/opencv_contrib
fi
cd opencv_contrib
git checkout $VERSION
cd ../
cd opencv
#git stash
# create platform file if not exist
if [ ! -f "platforms/linux/arm-musleabi.toolchain.cmake" ]; then
cat > platforms/linux/arm-musleabi.toolchain.cmake << "EOF"
set(GCC_COMPILER_VERSION "" CACHE STRING "GCC Compiler version")
set(GNU_MACHINE "arm-linux-musleabi" CACHE STRING "MUSL compiler triple")
include("${CMAKE_CURRENT_LIST_DIR}/arm.toolchain.cmake")
EOF

fi
# FIX  disable -mthumb option
sed -i -E "s/\-mthumb//" platforms/linux/arm.toolchain.cmake
rm -rf build
mkdir build
cd build
cmake  \
    -D BUILD_opencv_python3=ON \
    -D HAVE_opencv_python3=ON \
    -D OPENCV_SKIP_PYTHON_LOADER=ON \
    -D PYTHON3LIBS_VERSION_STRING=3.7m \
    -D PYTHON3_LIBRARIES=${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libpython3.7m.so.1.0 \
    -D PYTHON3_LIBRARY=${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libpython3.7m.so.1.0 \
    -D PYTHON_DEFAULT_EXECUTABLE=$(which python3.7) \
    -D PYTHON3_INCLUDE_PATH=${ANTIX_TOOLS}/${ANTIX_TARGET}/include/python3.7m \
    -D PYTHON3_INCLUDE_DIR=${ANTIX_TOOLS}/${ANTIX_TARGET}/include/python3.7m \
    -D PYTHON3_NUMPY_INCLUDE_DIRS=${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/python3.7/site-packages/numpy-1.17.0.dev0+c1bf6a6-py3.7-linux-x86_64.egg/numpy/core/include/ \
    -D OPENCV_PYTHON3_INSTALL_PATH=${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/python3.7/site-packages \
    -D CMAKE_TOOLCHAIN_FILE=../platforms/linux/arm-musleabi.toolchain.cmake \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -D ENABLE_NEON=ON \
    -D ENABLE_VFPV3=ON \
    ..
# make -j 8
make -j 16 install/strip
cp -arfv install/* ${ANTIX_TOOLS}/${ANTIX_TARGET}/
while true; do
    read -p "Do you wish to install openCV to root fs?" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit 0;;
        * ) echo "Please answer yes or no.";;
    esac
done
ARCH=$(echo ${MACHTYPE} | sed 's/-.*//')
cp -arfv install/lib/* ${ANTIX_ROOT}/usr/lib/
cp -arfv ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/python3.7/site-packages/cv2.cpython-37m-$ARCH-linux-gnu.so \
    ${ANTIX_ROOT}/usr/lib/python3.7/site-packages/cv2.so
exit 0
#! /bin/bash
export CC="${ANTIX_TARGET}-gcc --sysroot=${ANTIX_ROOT}" 
export CXX="${ANTIX_TARGET}-g++ --sysroot=${ANTIX_ROOT}" 
export AR="${ANTIX_TARGET}-ar" 
export AS="${ANTIX_TARGET}-as" 
export LD="${ANTIX_TARGET}-ld --sysroot=${ANTIX_ROOT}" 
export RANLIB="${ANTIX_TARGET}-ranlib"
export READELF="${ANTIX_TARGET}-readelf"
export STRIP="${ANTIX_TARGET}-strip" 
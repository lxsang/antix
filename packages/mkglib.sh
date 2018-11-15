#! /bin/bash
# require meson autoconf ninja to be installed
# depend on util-linux (libmount) optional
# libffi
set -e
. ../env.sh
#. ../toolchain.sh
file="2.58.1"
dir="glib-2.58.1"
cd ${ANTIX_BASE}/source
if [ ! -f "${file}.tar.gz" ]; then
    # download it
    wget https://github.com/GNOME/glib/archive/${file}.tar.gz
fi
tar xvf ${file}.tar.gz
cd ${dir}
# create cross file
test -f cross_file.txt && rm cross_file.txt
cat > cross_file.txt << "EOF"
[host_machine]
system = 'linux'
cpu_family = 'arm'
cpu = 'armv6zk'
endian = 'little'

[properties]
c_link_args = []
growing_stack=false

EOF
echo "c_args = ['--sysroot=${ANTIX_ROOT}']" >> cross_file.txt
echo "" >> cross_file.txt
echo "[binaries]" >> cross_file.txt
echo "c = '${ANTIX_TARGET}-gcc'" >> cross_file.txt
echo "cpp = '${ANTIX_TARGET}-g++'" >> cross_file.txt
echo "ar = '${ANTIX_TARGET}-ar'">> cross_file.txt
echo "strip = '${ANTIX_TARGET}-strip'">> cross_file.txt
#echo "ld='${ANTIX_TARGET}-ld --sysroot=${ANTIX_ROOT}'">>cross_file.txt
echo "pkgconfig = 'pkg-config'" >> cross_file.txt
/usr/local/bin/meson --cross-file cross_file.txt\
    --prefix ${ANTIX_TOOLS}/${ANTIX_TARGET}\
    --libdir ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib\
    -D selinux=false\
    -D libmount=false \
    -D internal_pcre=true \
    -D installed_tests=false \
    ./build
cd build
ninja -j 10
ninja install
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libgio*.so* ${ANTIX_ROOT}/usr/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libglib*.so* ${ANTIX_ROOT}/usr/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libgmodule*.so* ${ANTIX_ROOT}/usr/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libgobject*.so* ${ANTIX_ROOT}/usr/lib
cp -avrf ${ANTIX_TOOLS}/${ANTIX_TARGET}/lib/libgthread*.so* ${ANTIX_ROOT}/usr/lib
cd ${ANTIX_BASE}/source
rm -rf  ${dir}
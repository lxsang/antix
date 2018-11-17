#! /bin/bash
set -e
./mkrootfs-min.sh
cd packages
./mkncurse.sh
./mkreadline.sh
./mkzlib.sh
./mknetplug.sh
./mkdropbear.sh
# since busybox comes with
# sh and ash as shells, we dont really
# need bash for casual use.
# It can be install with the apk-tool.
# it is listed here as an optional
# option:
# ./mkbash.sh
sudo ./mksudo.sh
./mklibjpeg.sh
./mklibpng.sh "1.2.59"
./mkexpat.sh
./mkfreetype.sh "no"
./mkharfbuzz.sh
./mkfreetype.sh "yes"
./mkfontconfig.sh
./mklibdrm.sh
./mkmesa.sh
# qt
./mkqt5embeded.sh
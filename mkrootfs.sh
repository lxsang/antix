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
./mksqlite3.sh
./mklibssl.sh
./mkapk.sh
./mkantd.sh
sudo ./mksudo.sh

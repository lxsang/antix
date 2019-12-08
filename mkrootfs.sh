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
./mklibnl.sh
./mkwpasupplicant.sh
sudo ./mksudo.sh
./mklibffi.sh
./mkantd.sh
# compreess: sudo tar jcvf
# xtract: sudo tar xvpf 
# chown -Rv 0:0 ./
#chgrp -v 13 ./var/log/lastlog
#mknod -m 0666 ./dev/null c 1 3
#mknod -m 0600 ./dev/console c 5 1

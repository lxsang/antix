#! /bin/bash
set -e
./mkrootfs-min.sh
cd packages
./mkncurse.sh
./mkreadline.sh
./mkzlib.sh
./mknetplug.sh
./mkdropbear.sh
./mkbash.sh
./mksqlite3.sh
./mkopenssl.sh
./mkapk.sh
./mkantd.sh
sudo ./mksudo.sh
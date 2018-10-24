#! /bin/bash
./mkrootfs-min.sh
cd packages
./mkncurse.sh
./mkreadline.sh
./mkbash.sh
./mksqlite3.sh
./mkopenssl.sh
./mkantd.sh
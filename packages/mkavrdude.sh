#! /bin/bash
# build wiring pi library
# for raspberry Pi flavor devices
set -e
. ../env.sh
. ../toolchain.sh
cd ${ANTIX_BASE}/source
if [ ! -d "avrdude" ]; then
    # download it
    git clone https://github.com/sigmike/avrdude
    cd avrdude
else
    cd avrdude
fi
# now configure the code
./bootstrap
./configure \
    --build=${ANTIX_HOST}\
    --host=${ANTIX_TARGET}
make clean
make
cp -av avrdude ${ANTIX_ROOT}/usr/bin/
mkdir -p ${ANTIX_ROOT}/usr/local/etc/
cp -av avrdude.conf ${ANTIX_ROOT}/usr/local/etc/
# create the programmer for raspberry Pi
if [ "${ANTIX_BOARD}" = "npineo" ]; then
    echo "[Skip generating resettable programmer]"
else
cat > ${ANTIX_ROOT}/usr/bin/fwflash << "EOF"
#! /bin/sh
if [ "$#" -ne 1 ]; then
	echo "usage: $0 hex_file"
	exit 0
fi
rst="18"
delay=1
echo $rst > /sys/class/gpio/unexport
 
# then run the programmer
echo "Running programmer"
avrdude  -v -p atmega328p -c arduino -P /dev/ttyAMA0 -b115200 -D -Uflash:w:$1:i & 
# reset the chip
echo "Resetting the chip"
sleep $delay
echo $rst > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio$rst/direction
echo "1"> /sys/class/gpio/gpio$rst/value
sleep $delay
echo "0" > /sys/class/gpio/gpio$rst/value
#wait for the background command finish
wait $!
# run the program
echo "Run the program"
echo "1"> /sys/class/gpio/gpio$rst/value
sleep $delay
echo "0"> /sys/class/gpio/gpio$rst/value
sleep $delay
echo $rst > /sys/class/gpio/unexport
EOF
chmod a+x ${ANTIX_ROOT}/usr/bin/fwflash
fi
exit 0
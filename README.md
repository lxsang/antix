# antix
The build step is based on CLFS.

Support:
* Nano pi neo
* Raspberry Pi V1: Zero, A, A+, B, B+
* Rapberrry Pi V2: not yet (in comming)

## Host Requirement

    Bash-4.0
    Binutils-2.20
    Bzip2-1.0.5
    Coreutils-8.1
    Diffutils-3.0
    Findutils-4.4.0
    Gawk-3.1
    GCC-4.4
    Glibc-2.11
    Grep-2.6
    Gzip-1.3
    M4-1.4.16
    Make-3.81
    ncurses5
    Patch-2.6
    Sed-4.2.1
    Sudo-1.7.4p4
    Tar-1.23
    Texinfo-4.13
```sh
# Test if the host system satisfies all the requirements
cat > version-check.sh << "EOF"
#!/bin/bash

# Simple script to list version numbers of critical development tools
set -e
bash --version | head -n1 | cut -d" " -f2-4
echo -n "Binutils: "; ld --version | head -n1 | cut -d" " -f3-
bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6-
echo -n "Coreutils: "; chown --version | head -n1 | cut -d")" -f2
diff --version | head -n1
find --version | head -n1
gawk --version | head -n1
gcc --version | head -n1
ldd $(which ${SHELL}) | grep libc.so | cut -d ' ' -f 3 | ${SHELL} | head -n 1 \
| cut -d ' ' -f 1-10
grep --version | head -n1
gzip --version | head -n1
m4 --version | head -n1
make --version | head -n1
echo "#include <ncurses.h>" | gcc -E - > /dev/null
patch --version | head -n1
sed --version | head -n1
sudo -V | head -n1
tar --version | head -n1
makeinfo --version | head -n1

EOF

bash version-check.sh
```

## Guide
```sh
# Execute
./bake.sh
# Then follow the instruction
```

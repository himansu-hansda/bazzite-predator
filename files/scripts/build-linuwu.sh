#!/usr/bin/env bash
set -oue pipefail

# Find the exact kernel version (ignoring debug folders)
KVER=$(ls /usr/lib/modules | grep -v 'debug' | head -n 1)

# Clone the Linuwu-Sense repository
git clone https://github.com/0x7375646F/Linuwu-Sense.git /tmp/Linuwu-Sense
cd /tmp/Linuwu-Sense

# Compile the module against the matched Bazzite kernel
make KDIR=/usr/lib/modules/$KVER/build

# Move the compiled module into the system
mkdir -p /usr/lib/modules/$KVER/extra
cp linuwu_sense.ko /usr/lib/modules/$KVER/extra/

# Update module dependencies so it loads on boot
depmod -a -b /usr $KVER

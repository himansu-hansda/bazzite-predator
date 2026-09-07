#!/usr/bin/env bash
set -oue pipefail

# Find the exact kernel version inside the Bazzite image
KVER=$(ls /usr/lib/modules | head -n 1)

# Install the necessary build tools and kernel headers
rpm-ostree install kernel-devel-$KVER gcc make git

# Clone the Linuwu-Sense repository
git clone https://github.com/0x7375646F/Linuwu-Sense.git /tmp/Linuwu-Sense
cd /tmp/Linuwu-Sense

# Compile the module against the Bazzite kernel
make KDIR=/usr/lib/modules/$KVER/build

# Move the compiled module into the system
mkdir -p /usr/lib/modules/$KVER/extra
cp linuwu_sense.ko /usr/lib/modules/$KVER/extra/

# Update module dependencies
depmod -a -b /usr $KVER

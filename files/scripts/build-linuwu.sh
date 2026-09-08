#!/usr/bin/env bash
set -oue pipefail

# Find the exact kernel version
KVER=$(ls /usr/lib/modules | grep -v 'debug' | head -n 1)
echo "Found Kernel Version: $KVER"

# Clone the Linuwu-Sense repository
echo "Cloning repository..."
git clone https://github.com/0x7375646F/Linuwu-Sense.git /tmp/Linuwu-Sense
cd /tmp/Linuwu-Sense

# Compile the module against the matched Bazzite kernel
echo "Compiling the module..."
make KDIR=/usr/lib/modules/$KVER/build

# Move the compiled module into the system
echo "Installing the module to extra folder..."
mkdir -p /usr/lib/modules/$KVER/extra
cp linuwu_sense.ko /usr/lib/modules/$KVER/extra/

# Update module dependencies so it loads on boot
echo "Running depmod..."
depmod -a -b /usr $KVER

echo "Linuwu-Sense installation complete!"

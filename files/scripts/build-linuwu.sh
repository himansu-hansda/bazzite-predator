#!/usr/bin/env bash
set -x  # Turns on debug mode to log everything
set -ou pipefail

# 1. Find the exact kernel version
KVER=$(ls /usr/lib/modules | grep -v 'debug' | head -n 1)
echo "Found Kernel Version: $KVER"

# 2. Clear any cached folders and clone the repo
rm -rf /tmp/Linuwu-Sense
git clone https://github.com/0x7375646F/Linuwu-Sense.git /tmp/Linuwu-Sense
cd /tmp/Linuwu-Sense

# 3. Attempt compilation
echo "Attempting to compile with standard GCC..."
if ! make KDIR=/usr/lib/modules/$KVER/build; then
    echo "GCC failed. Attempting to compile with Clang/LLVM (Bazzite gaming kernel)..."
    make CC=clang LD=ld.lld KDIR=/usr/lib/modules/$KVER/build
fi

# 4. Install the compiled module
echo "Installing the module..."
mkdir -p /usr/lib/modules/$KVER/extra
cp linuwu_sense.ko /usr/lib/modules/$KVER/extra/

# 5. Update dependencies
depmod -a -b /usr $KVER
echo "Module built successfully!"

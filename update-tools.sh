#!/usr/bin/env bash
set -e

mkdir -p rootfs/usr/bin
rm -rf build/

echo "> Downloading wait-for-it..."
wget -O rootfs/usr/bin/wait-for-it https://raw.githubusercontent.com/jdufner/wait-for-it/9730b3a4817084a2504a2f553b316cf211166acd/wait-for-it.sh

echo "> Make wait-for-it executable..."
chmod +x rootfs/usr/bin/wait-for-it

echo "> Done!"

#!/usr/bin/env bash
set -e

mkdir -p rootfs/usr/bin

echo "> Downloading dockerize..."
wget -O - https://github.com/jwilder/dockerize/releases/download/v0.4.0/dockerize-alpine-linux-amd64-v0.4.0.tar.gz | tar -C rootfs/usr/bin -xzvf -

echo "> Make dockerize executable..."
chmod +x rootfs/usr/bin/dockerize

echo "> Downloading wait-for-it..."
wget -O rootfs/usr/bin/wait-for-it https://raw.githubusercontent.com/jdufner/wait-for-it/9730b3a4817084a2504a2f553b316cf211166acd/wait-for-it.sh

echo "> Make wait-for-it executable..."
chmod +x rootfs/usr/bin/wait-for-it

echo "> Done!"

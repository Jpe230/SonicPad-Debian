#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

./create_rootfs.sh
./pack_img.sh

echo "Happy hacking"
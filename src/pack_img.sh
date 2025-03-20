#!/bin/bash

set -e

SHELLTRAP=
source spinner.sh

# ---------------------------------------
KERNEL_ARCHIIVE=./archives/kernel_tools.tar.gz
PREBUILT_KERNEL=./prebuilt_kernel
TEMP_DIR=./temp
TOOLS_DIR=$PREBUILT_KERNEL/tools
ROOTFS_IMG=$PREBUILT_KERNEL/images/rootfs.img
ROOTFS_DIR=./rootfs
EXT4_IMG=$TEMP_DIR/rootfs.ext4
MOUNT_POINT=$TEMP_DIR/mount-point
OUT_DIR="./out"
IMAGE_NAME=tina_r818-sonic_lcd_uart0.img
OUT_IMAGE_NAME=debian_r818_sonic_lcd_uart0.img
OG_USER=${SUDO_USER:-$(whoami)}
# ---------------------------------------

# ---------------- IMG config------------
IMG_SIZE=4000000000
#IMG_SIZE=2684354560
BLOCKS=4096
INODES_RATIO=16384
INODES=$(($IMG_SIZE / $INODES_RATIO))
#----------------------------------------

start_spinner "Extracting kernel tools"
{
    rm -rf $PREBUILT_KERNEL
    mkdir -p $PREBUILT_KERNEL
    tar -xzf $KERNEL_ARCHIIVE -C $PREBUILT_KERNEL
} &> $SHELLTRAP

start_spinner "Creating ext4 partition"
{
    mkdir -p $TEMP_DIR
    rm -f $EXT4_IMG
    $TOOLS_DIR/make_ext4fs -l $IMG_SIZE -b $BLOCKS -i $INODES -m 0 $EXT4_IMG #The "dragon" doesnt like images made without their stupid tool
    rm -f $ROOTFS_IMG
    dd if=$EXT4_IMG of=$ROOTFS_IMG bs=128k conv=sync
    rm -f $EXT4_IMG
} &> $SHELLTRAP
stop_spinner

echo "Done creating ext4 partition"

start_spinner "Copying partitions"
{
    mkdir -p $MOUNT_POINT
    mount -o loop $ROOTFS_IMG $MOUNT_POINT
    cp -rfp $ROOTFS_DIR/* $MOUNT_POINT
    umount $MOUNT_POINT
    rm -r $MOUNT_POINT
} &> $SHELLTRAP
stop_spinner

echo "Done copying rootfs"

start_spinner "Fixing img"
{
    set +e
    tune2fs -O^resize_inode $ROOTFS_IMG
    e2fsck -yf $ROOTFS_IMG
    fsck.ext4 $ROOTFS_IMG
    set -e
} &> $SHELLTRAP
stop_spinner

echo "Done fixing img"

start_spinner "Resizing img"
{
    resize2fs -M $ROOTFS_IMG
} &> $SHELLTRAP
stop_spinner

echo "Done Resizing img"

start_spinner "Packing image"
{
    cd $PREBUILT_KERNEL
    ./tools/dragon image.cfg sys_partition_for_dragon.fex
} &> $SHELLTRAP
stop_spinner

echo "Done Packing image"

start_spinner "Moving our final image"
{
    cd ../
    mkdir -p $OUT_DIR
    rm -f $OUT_DIR/$IMAGE_NAME
    mv $PREBUILT_KERNEL/$IMAGE_NAME $OUT_DIR/$OUT_IMAGE_NAME
    chown $OG_USER $OUT_DIR/$OUT_IMAGE_NAME
} &> $SHELLTRAP
stop_spinner

echo "Done moving our final image"

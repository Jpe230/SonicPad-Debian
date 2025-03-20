#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

SHELLTRAP=
source spinner.sh
source .config

# Validate directories
if [ -z "$ROOTFS_DIR" ]
then
    echo "\$ROOTFS_DIR is empty"
    exit;
fi
if [ -z "$BASEFS_DIR" ]
then
    echo "\$BASEFS_DIR is empty"
    exit;
fi

echo "--------CONFIG---------"
echo "L_USERNAME: $L_USERNAME"
echo "DEB_DISTRO: $DEB_DISTRO"
echo "DEB_URL   : $DEB_URL"
echo "ROOTFS_DIR: $ROOTFS_DIR"
echo "BASEFS_DIR: $BASEFS_DIR"
echo "-----------------------"

# 0) Clear rootfs folder
if [ -d "$ROOTFS_DIR" ]
then
	if [ "$(ls -A $ROOTFS_DIR)" ]; then
        echo "The dir: $ROOTFS_DIR is not empty, this script will delete it."
        read -p "Do you want to proceed? (Y/n) " yn
        case $yn in
            Y ) echo ok, we will proceed;;
            n ) echo exiting...;
                exit;;
            * ) echo invalid response;
                exit 1;;
        esac
	fi
fi

start_spinner "Removing old rootfs"
rm -rf $ROOTFS_DIR
stop_spinner

# 1) Create a basic rootfs
start_spinner "Creating a basic rootfs"
{
    apt-get update
    apt-get install qemu-user-static -y
    apt-get install debootstrap -y # Install only debootstrap, pi doesnt need it
    debootstrap --no-check-gpg --foreign --verbose --arch=arm64 $DEB_DISTRO $ROOTFS_DIR $DEB_URL
    sed -i "s/$DEB_DISTRO main/$DEB_DISTRO main contrib/" $ROOTFS_DIR/etc/apt/sources.list
    cp /usr/bin/qemu-arm-static $ROOTFS_DIR/usr/bin/
    chmod +x $ROOTFS_DIR/usr/bin/qemu-arm-static
} &> $SHELLTRAP
stop_spinner

echo "Done creating bare rootfs"

# 2) Run second stage bootstrao on rootfs
start_spinner "Running second stage"
{
    LC_ALL=C LANGUAGE=C LANG=C chroot $ROOTFS_DIR /debootstrap/debootstrap --second-stage --verbose
} &> $SHELLTRAP
stop_spinner

echo "Done running second stage"

# # 3) Installing packages
start_spinner "Installing packages"
{
    LC_ALL=C LANGUAGE=C LANG=C chroot $ROOTFS_DIR apt update
    LC_ALL=C LANGUAGE=C LANG=C chroot $ROOTFS_DIR apt install git net-tools build-essential locales openssh-server wget libssl-dev sudo network-manager systemd-timesyncd u-boot-tools -y
} &> $SHELLTRAP
stop_spinner

echo "Done installing packages"

# 4) Copy our base filesystem
start_spinner "Copying base rootfs"
{
    cp -r $BASEFS_DIR/etc/* $ROOTFS_DIR/etc/
    cp -r $BASEFS_DIR/usr/local/bin/* $ROOTFS_DIR/usr/local/bin/
    cp -r $BASEFS_DIR/lib/firmware/ $ROOTFS_DIR/lib/
    cp -r $BASEFS_DIR/lib/modules/ $ROOTFS_DIR/lib/
} &> $SHELLTRAP
stop_spinner

echo "Done creating copying base rootfs"

# 5) Create default user
start_spinner "Creating default user"
{
    LC_ALL=C LANGUAGE=C LANG=C chroot $ROOTFS_DIR adduser --gecos "" --disabled-password $L_USERNAME
    LC_ALL=C LANGUAGE=C LANG=C chroot $ROOTFS_DIR chpasswd <<<"$L_USERNAME:$L_PASSWORD"
    LC_ALL=C LANGUAGE=C LANG=C chroot $ROOTFS_DIR /bin/bash -c "usermod -aG sudo $L_USERNAME"
} &> $SHELLTRAP
stop_spinner

echo "Done creating rootfs"

start_spinner "Installing Klipper, Moonraker, KlipperScreen"
{
    cp -r scripts $ROOTFS_DIR/home/$L_USERNAME/
    chmod +x $ROOTFS_DIR/home/$L_USERNAME/scripts/*.sh
    LC_ALL=C LANGUAGE=C LANG=C chroot $ROOTFS_DIR /bin/bash -c "echo '$L_USERNAME ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"
    LC_ALL=C LANGUAGE=C LANG=C chroot $ROOTFS_DIR /bin/su -c "cd /home/$L_USERNAME/scripts && ./install_services.sh" - $L_USERNAME
    LC_ALL=C LANGUAGE=C LANG=C chroot $ROOTFS_DIR /bin/bash -c "sed -i '$ d' /etc/sudoers"
    LC_ALL=C LANGUAGE=C LANG=C chroot $ROOTFS_DIR /bin/bash -c "rm -rf /home/$L_USERNAME/scripts"
    LC_ALL=C LANGUAGE=C LANG=C chroot $ROOTFS_DIR /bin/bash -c "echo '$L_USERNAME ALL = NOPASSWD:/bin/brightness' >> /etc/sudoers"
} &> $SHELLTRAP
stop_spinner

echo "Done installing services"

#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

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
    #apt-get install qemu-user-static -y
    apt-get install debootstrap -y # Install only debootstrap, pi doesnt need it
    debootstrap --no-check-gpg --foreign --verbose --arch=armhf $DEB_DISTRO $ROOTFS_DIR $DEB_URL
    #cp /usr/bin/qemu-arm-static $ROOTFS_DIR/usr/bin/
    #chmod +x $ROOTFS_DIR/usr/bin/qemu-arm-static
} &> /dev/null
stop_spinner


# 2) Run second stage bootstrao on rootfs
start_spinner "Running second stage"
{
    LC_ALL=C LANGUAGE=C LANG=C chroot $ROOTFS_DIR /debootstrap/debootstrap --second-stage --verbose
} &> /dev/null
stop_spinner

# # 3) Installing packages
start_spinner "Installing packages"
{
    LC_ALL=C LANGUAGE=C LANG=C chroot $ROOTFS_DIR apt update
    LC_ALL=C LANGUAGE=C LANG=C chroot $ROOTFS_DIR apt install git net-tools build-essential locales openssh-server wget libssl-dev sudo network-manager systemd-timesyncd -y
} &> /dev/null
stop_spinner


# 4) Copy our base filesystem
start_spinner "Copying base rootfs"
{
    cp -r $BASEFS_DIR/etc/* $ROOTFS_DIR/etc/
    cp -r $BASEFS_DIR/usr/local/bin/* $ROOTFS_DIR/usr/local/bin/
    cp -r $BASEFS_DIR/lib/firmware/ $ROOTFS_DIR/lib/
    cp -r $BASEFS_DIR/lib/modules/ $ROOTFS_DIR/lib/
}
stop_spinner


# 5) Create default user
start_spinner "Creating default user"
{
    LC_ALL=C LANGUAGE=C LANG=C chroot $ROOTFS_DIR adduser --gecos "" --disabled-password $L_USERNAME
    LC_ALL=C LANGUAGE=C LANG=C chroot $ROOTFS_DIR chpasswd <<<"$L_USERNAME:$L_PASSWORD"
    LC_ALL=C LANGUAGE=C LANG=C chroot $ROOTFS_DIR /bin/bash -c "usermod -aG sudo $L_USERNAME"
} &> /dev/nul
stop_spinner

echo "Done creating rootfs"


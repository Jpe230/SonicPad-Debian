
# How to build your own Distro

## About the procedure:

Using mainline's kernel is out of the question since it requires serious patching because of the lack of support of the SOC (R818).

To boot Debian, we are going to use the kernel provided by AllWinner and replace the rootfs before packing it.
Originally, Tina uses a Read Only filesystem (squashfs) with an OverlayFS, I assume this is done to avoid corruption.

We are going to replace this behaviour by using a single EXT4 partition.
__________________________________________________________________________________

This repo include the tools and a precompiled kernel to pack the final image, these files were taken directly from a build of the original Creality Repo,
by doing so, we avoid hacking the buildroot and all the woes that the SDK does.

This procedure was tested using:
* Ubuntu LTS 22.04
* Ubuntu 23.04
* WSL2

## Clone this repo

```bash
git clone https://github.com/Jpe230/SonicPad-Debian
```

## Create a rootfs

The [included scripts](src) in this repo, do the following:
* Create a basic rootfs
* Install utils packages
* Copy kernel modules and enable them
* Load the required service: 
  * Run `depmod` at boot
  * Run `resize2fs` once at boot
  * Enable LED as EMMC indicator
  * Enable CAM port as USB host
* Install Klipper, Moonraker and KlipperScreen

To generate the rootfs used for the release:

```bash
cd Sonicpad-Debian/src
sudo ./create_rootfs.sh
```

In case you want to build your own rootfs using another tool or distro:
* Copy and load [the kernel modules](src/base_rootfs/lib/)

## Pack rootfs into a EXT4 Partition

Once you have a rootfs you will need to pack it:

```bash
sudo ./pack_img.sh
```
This script creates an empty ext4 image and then recursively copies the rootfs into it.
Sadly it needs to be done using their tools because the packer doesn't like images made with `mkfs.ext4`

It expects a rootfs at the following location:

```bash
src/rootfs
```

## Pack Uboot + Kernel + Rootfs

The previous script executes the program `dragon` it is distributed as binary from Allwinner and sadly there is no FOSS alternative.

It expects a boot.img and rootfs.img at the following location
```bash
src/prebuilt_kernel/images
```

If all went well it should generate a valid flashable image.

## Flash

Finally you can flash your Sonic Pad with the OS of your choice.

The steps are as follow
1) Download the binaries from Creality's repo
2) Open the LiveSuit/PhoenixSuit
3) Select the image
4) Connect the Pad in FEL Mode
5) Flash
6) Enjoy!



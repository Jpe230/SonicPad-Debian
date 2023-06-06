# SonicPad Debian


# About
A repo with a set of steps to replace the existing OS (OpenWRT/Tina Linux/CrealityOS) with Debian.

The main goal is to achieve the use of the maiinline sources for Klipper, Mainsail, Fluidd and KlipperScreen.

Please visit the following links to learn more:

* Klipper (Operating System): https://www.klipper3d.org/ 
* Moonraker (API Web Server): https://moonraker.readthedocs.io/ 
* Mainsail (Web Interface): https://docs.mainsail.xyz/ 
* KlipperScreen (Screen Interface): https://klipperscreen.readthedocs.io/ 

**Please take in mind that this will certainly void your warranty and is not endorse by Creality in any way.**


# Recommendations

## Flash the recovery image

While not neccesary, it is recommended to flash the recovery image just to test the provided tools by Creality.

You will need a USB-A to USB-A cable. They can be found easily at Amazon.

The recovery image is located at [Creality's repo](https://github.com/CrealityOfficial/Creality_Sonic_Pad_Firmware/tree/main/imgs)

Please use their instructions in how to set the drivers.

### Flashing with macOS

You will need trust the developer of the flasher otherwise it won't let you open the executable.

You will need to re-open the executable multiple times and trust the author.

## UART

I seriously recommend buying a cheap UART to USB adapter and soldering wires to the exposed pads at the bottom of the PCB.


# Preparation

## Compile Tina

Please refer to the repository for the CrealityOS: https://github.com/CrealityTech/sonic_pad_os

Follow their instructions to compile it, additionally you can try to flash it just to see if it works.

## Configure Tina

Using mainline's kernel is out of the question since it requires serious patching because of the lack of support of the SOC (R818). 

To boot Debian, we are going to use the kernel provided by AllWinner and replace the rootfs before packing it.

Originally, Tina uses a Read Only filesystem (squashfs) with an OverlayFS, I assume this is done to avoid corruption. 

We are going to replace this behaviour by using a single EXT4 partition.

### Configure Tina with an EXT4 rootfs:
The steps are as follow: 

cd into the "sonic_pad_os" repo:
```
cd **replace with the sonic_pad_os dir**
```

Config the Tina enviroment:
```
source build/envsetup.sh
```

"Lunch":
```
lunch 6
```

Configure EXT4:
```
make menuconfig
```

A menu will appear:

<img here>

Go to `Target Images`:

<img here>

Disable `squashfs` and enable `ext4`:

<img here>


Make the ext4 partition bigger, I use 1GB.

<img here>

You can always increase the size if your rootfs doesn't fit.  


Compile Tina with: 

```
make
```
  
Make sure that it compiled, and a `rootfs.img` file was generate at `sonic_pad_os/out/r818-sonic_lcd/`


### Create a Debian RootFS

We are going to use a `debootstrap` to create a rootfs, but you are free to choose whatever distro you want.

Run the following:
```
# Run as sudo
sudo -i

# Install necessary packages:
sudo apt-get install qemu-user-static debootstrap

# Use `debootstrap` to create a basic rootfs:
debootstrap --no-check-gpg --foreign --verbose --arch=armhf buster rootfs http://deb.debian.org/debian/

# Copy qemu into the rootfs:
cp /usr/bin/qemu-arm-static rootfs/usr/bin/
chmod +x rootfs/usr/bin/qemu-arm-static

# Chroot into the filesystem:
LC_ALL=C LANGUAGE=C LANG=C chroot rootfs
```

The following is meant to be run inside the `chrooted rootfs`:
```
# Run debootstrap:
/debootstrap/debootstrap --second-stage --verbose

# Set hostname
echo "SonicPad" > /etc/hostname

# Configure root password:
passwd

# Update sources
apt update

# Install utils packages
apt install git net-tools wpasupplicant build-essential locales openssh-server wget libssl-dev sudo

# Install cmake for klipperscreen:
wget https://github.com/Kitware/CMake/releases/download/v3.26.4/cmake-3.26.4.tar.gz
tar -xvzf cmake-3.26.4.tar.gz
rm cmake-3.26.4.tar.gz
cd cmake-3.26.4
./bootstrap
make
make install
cd ../
rm -rf cmake-3.26.4

# Configure fstab:
echo "PARTLABEL="rootfs" / ext4 noatime,lazytime,rw 0 0" > /etc/fstab

# Configure the loading of kernel modules
ln -fs /lib/systemd/system/rc-local.service /etc/systemd/system/rc-local.service
touch /etc/rc.local
chmod +x /etc/rc.local
systemctl enable rc.local

# Configure WiFi MACADDRESS (Generate your own)
mkdir /etc/wifi
echo "FC:EE:92:11:14:05" > /etc/wifi/xr_wifi.conf

# Clean cache
apt clean
rm -rf /var/cache/apt/

# Configure user
adduser <your username>
usermod -aG sudo <your username>

# Exit roofs
exit
```

Copy the kernel modules located at `sonic_pad_os/out/r818-sonic_lcd/staging_dir/target/rootfs/lib` to the rootfs

```
cp -r /home/[path to repo]/sonic_pad_os/out/r818-sonic_lcd/staging_dir/target/rootfs/lib/firmware/ rootfs/lib/
cp -r /home/[path to repo]/sonic_pad_os/out/r818-sonic_lcd/staging_dir/target/rootfs/lib/modules/ rootfs/lib/
```

Edit rootfs `/etc/rc.local`:

You will need to load GPU, Wifi, configure dhclient, you can find an example here.

Edit rootfs `/etc/wpa_supplicant.conf`:

Generate a valid conf, you can find an example here.


### Replace Rootfs with ours

Assuming you have compiled Tina:

Cd to out folder
```
cd sonic_pad_os/out/r818-sonic_lcd/
```

Mount Tina `rootfs` 

```
mkdir mountfs && mount-o loop rootfs.img mountfs
```

Delete Tina `rootfs` contents
```
cd mountfs
sudo rm -rf *
```

Copy our rootfs to the mount dir
```
sudo -i
cp -rfp rootfs/* /home/jpe230/SonicPadOS/out/r818-sonic_lcd/mountfs/
exit
```

Unmount image
```
umount mountfs
```

Repair image, accept all prompts
```
tune2fs -O^resize_inode rootfs.img
fsck.ext4 rootfs.img
```

### Pack and flash

cd into the root of the repo and run:
```
pack
```

Flash with using Livesuit or PhoenixSuit


### Misc.

#### Brightness

Cross-compile or compile directly with the Pad, the `brightness.c` file located in this repo.

Example usage:
```
./brightness -h 
```






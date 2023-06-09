# SonicPad Debian


# About

A repo with a set of steps to replace the existing OS (OpenWRT/Tina Linux/CrealityOS) with Debian.

The main goal is to achieve the use of the maiinline sources for Klipper, Mainsail, Fluidd and KlipperScreen.

Please visit the following links to learn more:

* Klipper (Operating System): https://www.klipper3d.org/ 
* Moonraker (API Web Server): https://moonraker.readthedocs.io/ 
* Mainsail (Web Interface): https://docs.mainsail.xyz/ 
* KlipperScreen (Screen Interface): https://klipperscreen.readthedocs.io/ 

# Prebuilt Debian 10 Buster

A prebuilt image is available at the "Releases" tab.

The image is configured with:
* Klipper
* Moonraker
* KliipperScreen

You can use [KIAUH](https://github.com/th33xitus/kiauh) to update/install more components.

The following libraries/packages are **missing** to reduce the size of the image, please install them if you need them:
* binutils-arm-none-eabi   
* libnewlib-arm-none-eabi
* libstdc++-arm-none-eabi-newlib
* gcc-arm-none-eabi

## Disclaimer

I'm not responsible for bricked devices, failed prints, etc. This is merely a place where I can share a personal project with the rest of the world.
* YOU are choosing to make these modifications, by no means I'm forcing you to replace the OS of you pad.
* The prebuilt image is "as-is", meaning, I don't plan to give it a long-term support, bugs or errors aren't my resposability.

**Please take in mind that this will certainly void your warranty and is not endorse by Creality in any way.**

## Prerequisites

You will need:
* USB A - USB A Cable

## Flashing the Soinc Pad

Please refer to [Creality's repo](https://github.com/CrealityOfficial/Creality_Sonic_Pad_Firmware) for flashing instructions as well as the tools neccesary for it.

## Post-Flashing

The Sonic Pad should boot directly to KlipperScreen, we need to SSH to finish configuring it.

1) In KlipperScreen, configure your WIFI network and get the IP of the Pad
2) SSH into the pad
```
ssh sonic@<your ip>
```
3) Expand the filesystem:
```
sudo resize2fs /dev/mmcblk0p5
```
4) Verify disk space with:
```
df -h
```
5) Install your frontend of choice using KIAUH:
```
kiauh/kiauh.sh
```
6) Additionally, if you are planning in compiling, or measuring resonance with Klipper, please install the following packages;
```
sudo apt install binutils-arm-none-eabi libnewlib-arm-none-eabi libstdc++-arm-none-eabi-newlib gcc-arm-none-eabi
```
7) Configure Klipper :)


# How to build your own Distro

Please visit [this section](https://github.com/Jpe230/SonicPad-Debian/blob/main/DIY.md) for a detailed walkthrough


# Misc.

## Areas of opportunity (Any PR is welcome) / TODOS

- [ ] Idle timeout: Creality has a script to turn off the display after 2 min of inactivity
- [ ] Replace the rootfs inside Tina SDK to avoid hacking the compiled img
- [x] ~~Create a prebuilt images ready to be flash~~
- [x] ~~Create a script to auto-mount a USB flashdrive to load `wpa_supplicant.conf`~~ Not needed

## To be tested

- [ ] Bluetooth (?) Dunno why you would need it but i haven't tested it
- [ ] Audio
- [x] ~~SPI port for Accelerometer~~ Please read: https://www.klipper3d.org/Measuring_Resonances.html
- [x] ~~Ethernet* managed to get an IP but I hadn't bothered configuring it. Should work OOB~~

## Brightness

A hacky way to control the display brightness is by using a CLI, the following code was sourced from Creality's repo.

Cross-compile or compile directly with the Pad, the `brightness.c` file located in this repo.

Example usage:
```
./brightness -h 
USAGE: brightness [OPTIONS] [value]
                     -s backlight switch [0|1]
                     -d dev mode range [0-255]
                     -v range default [0-100]

```

### Considerations

Since we are using a R/W fs, we need to avoid shutting down the pad un-gracefully, it can corrupt your fs and you are going to need to reflash it.

Please use KlipperScreen to turn off the Pad, then press the side-button to cut the power.

## Flashing with macOS

You will need trust the developer of the flasher otherwise it won't let you open the executable.

You will need to re-open the executable multiple times and trust the author.

## UART

I seriously recommend buying a cheap UART to USB adapter and soldering wires to the exposed pads at the bottom of the PCB. While not necessary it gives you a shell in case SSH or networking didn't work. 

According to chinese guys at https://aw-ol.com forums, fbcon is borked so no shell to the display hence the recommendation for a UART adapter

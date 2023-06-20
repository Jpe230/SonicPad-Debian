<p align="center">
  <a href="https://github.com/Jpe230/SonicPad-Debian/" title="SonicPad Logo">
    <img src="https://github.com/Jpe230/SonicPad-Debian/assets/6202305/ce559b28-9835-4447-809d-594a5bb70847" width="200px" alt="SonicPad Logo"/>
  </a>
</p>
<h1 align="center">🌟 SonicPad Debian 🌟</h1>
<p align="center">Port of Debian for the SonicPad (Allwinner R818)</p>

<h2 align="center">🌐 Links 🌐</h2>
<p align="center">
    <a href="https://github.com/Jpe230/SonicPad-Debian/releases" title="Releases">📂 Releases</a>
    ·
    <a href="https://github.com/Jpe230/SonicPad-Debian/issues/new/choose" title="Report Bug/Request Feature">🐛 Got an issue</a>
    .
    <a href="https://github.com/Jpe230/SonicPad-Debian/pulls" title="PR">🚀 Contribute a new feature </a>
</p>

## 🚀 Features

Ready to go Debian 11 Bullseye Image for the SonicPad!

The following packages pre-installed:

- **Klipper: https://www.klipper3d.org/**
- **Moonraker: https://moonraker.readthedocs.io/**
- **KlipperScreen: https://klipperscreen.readthedocs.io/**

## 🎚️ Prerequisites

- USB-A to USB-A Cable
- A Windows/Linux/macOS device to flash the SonicPad

## 🛠️ Installation Steps

1. Download the lastest [release image](https://github.com/Jpe230/SonicPad-Debian/releases)

2. Flash the Sonic Pad

>Please refer to [Creality's repo](https://github.com/CrealityOfficial/Creality_Sonic_Pad_Firmware) for a more detailed instructions as well as the tools neccesary for it.

3. In KlipperScreen, configure your WIFI network and get the IP of the Pad

4. SSH into the pad, the default login password is: `pad`

```bash
ssh sonic@<your ip>
```

5. Expand your partition

```
sudo resize2fs /dev/mmcblk0p5
```

5. Install your frontend of choice using KIAUH:
>Please refer to [th33xitus's repo](https://github.com/th33xitus/kiauh) for more detailed instructions.

6. Additionally, if you are planning in compiling, or measuring resonance with Klipper, please install the following packages:
```
sudo apt install avrdude gcc-avr binutils-avr avr-libc stm32flash binutils-arm-none-eabi libnewlib-arm-none-eabi libstdc++-arm-none-eabi-newlib gcc-arm-none-eabi
```

> ❗ These packages take a lot space. I recommend using a different host to build a firmware for your printer ❗

>

7. Configure your printer! 😁


**🎇 You are Ready to Go!**

## ❗ Available Commands

The prebuilt includes a CLI to control de brightness, to see its usage please run:

```Bash
sudo brightness -h
```

## 📂 Directory Structure

> [`src`](https://github.com/Jpe230/SonicPad-Debian/blob/main/src "src"): Scripts necessary to build a rootfs.

> [`src/prebuilt_kernel`](https://github.com/Jpe230/SonicPad-Debian/blob/main/src/prebuilt_kernel "src/prebuilt"): Prebuilt Kernel and tools necessary to pack the final image

> [`src/base_rootfs`](https://github.com/Jpe230/SonicPad-Debian/blob/main/src/base_rootfs "src/base_rootfs"): Files that are needed to be copied to the built rootfs 

> [`src/scripts`](https://github.com/Jpe230/SonicPad-Debian/blob/main/src/scripts "src/scripts"): Scripts to install Klipper, Moonraker, KlipperScreen

❗Want to build your own rootfs? Please see the [DIY Section](https://github.com/Jpe230/SonicPad-Debian/blob/main/DIY.md)

## 🎊 Future Updates

- [ ] Idle timeout: Creality has a script to turn off the display after 2 min of inactivity

- [x] ~~Replace the rootfs inside Tina SDK to avoid hacking the compiled img~~

- [x] ~~Create a prebuilt images ready to be flash~~

- [x] ~~Create a script to auto-mount a USB flashdrive to load `wpa_supplicant.conf`~~ Not needed

## 🪲 Known bugs

- Incorrect Interface shown in KlipperScreen

- Current IP doesn't show in KlipperScreen

## 👀 Disclaimers

Since we are using a R/W partition, we need to avoid shutting down the pad un-gracefully, it can corrupt your fs and you are going to need to reflash it.

>**Please use KlipperScreen to turn off the Pad, then press the side-button to cut the power.**
--------------------------

if you are planning in compiling, or measuring resonance with Klipper, please install the following packages:
```
sudo apt install binutils-arm-none-eabi libnewlib-arm-none-eabi libstdc++-arm-none-eabi-newlib gcc-arm-none-eabi
```

## 🤝 Support

- Contributions are most welcome!

I'm not responsible for bricked devices, failed prints, etc. This is merely a place where I can share a personal project with the rest of the world.

- YOU are choosing to make these modifications, by no means I'm forcing you to replace the OS of you pad.
- The prebuilt image is "as-is", meaning, I don't plan to give it a long-term support, bugs or errors aren't my resposability.

**Please take in mind that this will certainly void your warranty and is not endorse by Creality in any way.**


## 🪙 Credits

- The scripts used for installing Klipper are based on the great work of [KIAUH](https://github.com/th33xitus/kiauh)

- The CLI tool for controlling the brightness is taken from [Creality's repo](https://github.com/CrealityTech/sonic_pad_os)

- Klipper: https://www.klipper3d.org/

- Moonraker: https://moonraker.readthedocs.io/ 

- KlipperScreen: https://klipperscreen.readthedocs.io/




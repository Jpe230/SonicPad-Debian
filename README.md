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

Ready to go Debian 11 Bullseye Image for the SonicPad! Allows you to install the latest, unmodified, versions of software within the Klipper ecosystem.

The following packages are pre-installed:

- **Klipper: https://www.klipper3d.org/**
- **Moonraker: https://moonraker.readthedocs.io/**
- **KlipperScreen: https://klipperscreen.readthedocs.io/**

## 🎚️ Prerequisites

- USB-A Male to USB-A Male Cable
- A Windows/Linux/macOS device to flash the SonicPad

## 🛠️ Installation Steps

1. Download the latest [release image](https://github.com/Jpe230/SonicPad-Debian/releases)

2. Flash the Sonic Pad

>Please refer to [`docs/flashing.md`](docs/flashing.md) for detailed instructions. 

3. Using KlipperScreen, configure your WIFI network and get the IP of the Pad

4. SSH into the pad

```bash
ssh sonic@<your ip>
```

> ℹ️ The default login password is: `pad` 

5. (Optional) Configure SonicPad-Debian
> Documentation for further configuration options can be found in the [`docs/` directory](docs/). 

> This is where documentation for accelerometer support, timezones, KIAUH, Fluidd, Crowsnest, and others is found. 


6. Configure Klipper! 😁

**🎇 You are Ready to Go!**

## ❗ Available Commands

The prebuilt includes a CLI to control the brightness, to see its usage please run:

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

- [x] ~~Idle timeout: Creality has a script to turn off the display after 2 min of inactivity~~ (Dont forget to change the screen timeout in KlipperScreen)

- [x] ~~Replace the rootfs inside Tina SDK to avoid hacking the compiled img~~

- [x] ~~Create a prebuilt images ready to be flash~~

- [x] ~~Create a script to auto-mount a USB flashdrive to load `wpa_supplicant.conf`~~ Not needed

## 🪲 Known bugs

- Incorrect Interface shown in KlipperScreen

- Current IP doesn't show in KlipperScreen

## 👀 Disclaimers

⚠️ It should be noted that the SonicPad-Debian firmware, unlike the stock firmware, uses a read/write filesystem. This means that, just like your computer at home, removing the power unexpectedly can damage your files. **Do not use the button on the side of the SonicPad to turn it off.** You must gracefully shutdown using a GUI or by issuing the `shutdown` or `restart` commands ⚠️

## 🤝 Support

- Contributions are most welcome!

I'm not responsible for bricked devices, failed prints, etc. This is merely a place where I can share a personal project with the rest of the world.

- YOU are choosing to make these modifications, by no means I'm forcing you to replace the OS of your pad.
- The prebuilt image is provided "as-is"-- meaning, I don't plan to give it long-term support and bugs or errors aren't my responsibility.

**Please take in mind that this will certainly void your warranty and is not endorsed by Creality in any way.**


## 🪙 Credits

- The scripts used for installing Klipper are based on the great work of [KIAUH](https://github.com/th33xitus/kiauh)

- The CLI tool for controlling the brightness is taken from [Creality's repo](https://github.com/CrealityTech/sonic_pad_os)

- Klipper: https://www.klipper3d.org/

- Moonraker: https://moonraker.readthedocs.io/ 

- KlipperScreen: https://klipperscreen.readthedocs.io/




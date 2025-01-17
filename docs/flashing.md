# Flashing firmware to the SonicPad

The instructions for flashing firmware to your SonicPad will vary depending on the operating system you use. Creality/Allwinner have provided flashing software for Windows, MacOS, and Ubuntu Linux. 

The original documentation can be found in the [`officialInstructions/` directory](officialInstructions/), converted to `.pdf` for compatibility. 

 ⚠️ Should you ever need to go back to the official Creality firmware, images can be found in the [CrealityOfficial/Creality_Sonic_Pad_Firmware](https://github.com/CrealityOfficial/Creality_Sonic_Pad_Firmware/) repository ⚠️

## Prerequisites:
- A computer running Windows/MacOS/Ubuntu
- USB-A Male to USB-A Male Cable
- A small pin or other poking tool

## Platform Agnostic Steps
### 1) Obtain the firmware
> ⚠️ Should you ever need to go back to the official Creality firmware, images can be found in the [CrealityOfficial/Creality_Sonic_Pad_Firmware](https://github.com/CrealityOfficial/Creality_Sonic_Pad_Firmware/) repository ⚠️

1) Download these three files from the [SonicPad Debian GitHub Releases Page](https://github.com/Jpe230/SonicPad-Debian/releases/):
    - [`debian_r818_sonic_lcd_uart0.zip`](https://github.com/Jpe230/SonicPad-Debian/releases/download/v1.0-bullseye/debian_r818_sonic_lcd_uart0.zip)
    - [`debian_r818_sonic_lcd_uart0.z01`](https://github.com/Jpe230/SonicPad-Debian/releases/download/v1.0-bullseye/debian_r818_sonic_lcd_uart0.z01)
    - [`debian_r818_sonic_lcd_uart0.z02`](https://github.com/Jpe230/SonicPad-Debian/releases/download/v1.0-bullseye/debian_r818_sonic_lcd_uart0.z02)

>If you haven't seen it before, this is a multi part zip file. That is, the contents of the zip are spread out throughout the three files and you need all three to extract the full contents. 

2. Unzip the main `.zip` file, you will find a file inside called `debian_r818_sonic_lcd_uart0.img`

Keep track of this file, as we'll need it later.


>The next steps are platform dependent. Click to skip to the section relevant for your operating system.
>- [Windows](#windows)
>- [MacOS](#macos)
>- [Ubuntu Linux](#ubuntu-linux)


## Windows

### 2) Download and Open PhoenixSuit
1) Download [`PhoenixSuit_Windows_V1.10.zip`](tools/PhoenixSuit_Windows_V1.10.zip) from the [tools/](tools/) directory.
2) Unzip the file and enter the `PhoenixSuit_V1.10` directory.
> Remember where you put this directory as we will need it later
3) Open the `PhoenixSuit.exe` file.

After a few moments, PhoenixSuit will open. 

![image](https://github.com/user-attachments/assets/9af1f29e-40da-45ab-b489-4879e31f69f1)


4) Navigate to the `Firmware` tab. 
5) Click `Image`
6) Select the newly extracted `debian_r818_sonic_lcd_uart0.img` file. 

You can leave the software be for now. Do not close it.


### 3) Put the SonicPad in Burning Mode

1) Ensure the SonicPad is off

![image](https://github.com/user-attachments/assets/f2d37b18-5a34-4bf7-b38b-ec0605a5e6c0)

2) Connect one end of your [**USB A Male to USB A Male**](https://www.amazon.com/s?k=usb+a+male+to+usb+a+male) cable into the bottom port labeled `CAM` on the back of the Sonic Pad. Plug the other end into your computer.
> You must connect the USB to the CAM port, the other ports will not work

![image](https://github.com/user-attachments/assets/53126213-f95b-4dff-90db-be3d91a9a1a6)

3) Hold down the **outermost** recessed button with a small tool.

4) While pressing the recessed button, turn the SonicPad on.

The screen will remain black, but the light on the side will still illuminate. The device is now in **burning mode**.

### 4) Install Windows Drivers

![image](https://github.com/user-attachments/assets/f5e6b0df-4f3b-43b5-8f3b-f28b3cf42443)

1) Open **Device Manager**
2) Expand `Other Devices`
3) Right-click on `Unknown Device` and select `Update Driver` 
> There may be multiple devices listed here. If you want to confirm that this is indeed the SonicPad, disconnect the USB cable and check to see if the device listing disappears. 

![image](https://github.com/user-attachments/assets/cf173a1f-4327-49a0-a683-836301eceb5e)

4) In the newly opened window, select `Browse my computer for driver software`

![image](https://github.com/user-attachments/assets/0980fc0f-b7b0-4ff5-8d06-83eabb3264a7)

5) Select **"Browse"** and select the `PhoenixSuit_V1.10\Drivers` directory from the `.zip` you extracted earlier.

6) Click `Next` and the drivers will be installed

Once the drivers are installed, PhoenixSuit should pop up with a prompt. If it doesn't, try restarting the SonicPad and re-entering burning mode.

## 5) Flash the Firmware with PhoenixSuit
![image](https://github.com/user-attachments/assets/72ec923c-5346-4d80-89d4-d7363c17170c)

Once the drivers are installed, PhoenixSuit should have popped up with this message. If it has not, try restarting the SonicPad and re-entering burning mode.

1) Click `Yes` to start the flashing process.
>Do not interrupt the flashing process by unplugging the USB or turning either device off. This process may take 10 minutes or longer. Progress will be shown as it flashes the new firmware.

![image](https://github.com/user-attachments/assets/40ae51bc-d256-46ba-9675-b66eb3f40c27)

Once the flashing process has completed, a message will be shown. It is now safe to remove the USB connection.

>⚠️ It should be noted that the SonicPad-Debian firmware, unlike the stock firmware, uses a read/write filesystem. This means that, just like your computer at home, removing the power unexpectedly can damage your files. Do not use the button on the side of the SonicPad to turn it off. You must gracefully shutdown using a GUI or by issuing the `shutdown` or `restart` commands ⚠️

If all went well, you should see the Debian logo (a red swirl) while the SonicPad reboots. You are done flashing and can now begin configuring. See [the main README for steps on connecting to Wi-Fi and using SSH](/README.md#️-installation-steps). See the [`docs/` directory](docs/) for more information on configuring SonicPad-Debian, including setting a timezone and installing the accelerometer for resonance testing.




-----

## MacOS

1) Download [`PhoenixSuit_MacOS_T800.zip`](tools/PhoenixSuit_MacOS_T800.zip)

2) See the official instructions located at [officialInstructions/Sonic Pad Firmware Burning Tutorial_MacOS_V1.3.pdf](officialInstructions/Sonic%20Pad%20Firmware%20Burning%20Tutorial_MacOS_V1.3.pdf).

> Note that this is a command-line utility, without a GUI.

-----

## Ubuntu Linux

1) Obtain a copy of LiveSuit for Linux

    `LiveSuitV306_For_Linux64.zip`, which is mentioned in the official flashing instructions, has never been provided by Creality, and instead must be found elsewhere on the internet. Take caution.

    >Eventually, I plan to obtain this software directly from Allwinner and distribute it (with permission) within this repository.

    For now you can find the Linux version here:

    http://dl.cubieboard.org/software/tools/livesuit/LiveSuitV306_For_Linux64.zip

    https://github.com/lucatib/a33_writing_tools/blob/master/LiveSuitV306_For_Linux64.zip




2) See the official instructions located at [officialInstructions/Sonic Pad Firmware Burning Tutorial_Ubuntu_V1.1.pdf](officialInstructions/Sonic%20Pad%20Firmware%20Burning%20Tutorial_Ubuntu_V1.1.pdf).


# SonicPad-Debian Documentation


# Flashing

See [flashing.md](flashing.md) for instructions on how to flash a firmware image to the SonicPad.

# Configuring

See [fixTimezone.md](fixTimezone.md) for instructions on how to change the timezone. By default it is UTC+0.

See [installAccelerometer.md](installAccelerometer.md) for instructions on how to install and configure the accelerometer for resonance testing.

See [KIAUH](https://github.com/dw-0/kiauh) documentation for help installing Klipper instances


# General Configuration

**Connect to WiFi**
Using the touchscreen, select **Menu > Network** and connect to your WiFi network (or use Ethernet). Take note of the internal IP address your Sonic Pad is assigned after connecting to your WiFi. 

If you don't already have an SSH client installed, install [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) or download the [distributable .exe here](https://the.earth.li/~sgtatham/putty/latest/w64/putty.exe)

**Connect to your SonicPad using SSH**

$ `ssh sonic@<your-sonic-pad-ip>`

The default password is `pad`. For security, no characters will show up when typing the password. You may have to type "yes" to confirm connecting for the first time.

## **Change Default Passwords (optional but important)**

>Default Credentials:
>user: `root`, password: `toor`,
>user: `sonic`, password: `pad`

To change `root` user password:

$ `sudo passwd root` 

To change `sonic` user password:

$ `passwd sonic`


## **Update System**

$ `sudo apt-get update && sudo apt-get upgrade`


## **Install other 3D Printing Software with KIAUH**

SonicPad-Debian comes preinstalled with KIAUH the Klipper Installation And Update Helper. This will allow you to easily install or remove software like Klipper, Moonraker, Mainsail, Fluid, Crowsnest, and others. You can install and run KIAUH using the following commands:

> **as of release v1.0, KIUAH no longer comes packaged**

$ `cd ~ && git clone https://github.com/dw-0/kiauh.git`

$ `~/kiauh/kiauh.sh`

Follow the onscreen instructions to install the software you want.

*Klipper* - handles talking with the printer via serial

*Mainsail* - provides an API for Klipper, so other software can talk to the printer

*Moonraker* - web frontend for printer control (install one or both)

*Fluidd* - web frontend for printer control (install one or both)

*KlipperScreen* - provides GUI for Sonic Pad screen

## **Configure Installed Software**
You should be able to configure the software you have installed by editing config files located in the  `/home/sonic/printer_data/config` directory.

If you are experiencing any problems you can view the log files located at `/home/sonic/printer_data/config`.
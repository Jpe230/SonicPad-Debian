# Install Accelerometer

```bash
# Update package index
sudo apt update
# Install Dependencies
sudo apt install binutils-arm-none-eabi libnewlib-arm-none-eabi libstdc++-arm-none-eabi-newlib gcc-arm-none-eabi python3-numpy python3-matplotlib libatlas-base-dev
# Install numpy to our Klipper python virtual env
~/klippy-env/bin/pip install -v numpy
```
> ❗ These packages take a lot space. I recommend using a different host to build a firmware for your printer ❗

```bash
# Install Klipper MCU service to Systemd
sudo cp ~klipper/scripts/klipper-mcu.service /etc/systemd/system/
systemctl daemon-reload
```

Flash KlipperMCU. A GUI will appear, select `Linux Process`.

```bash
cd ~/klipper
make clean
make menuconfig # select "linux process" in the GUI
make flash
```

Add the following to the `printer.cfg`
```
[mcu rpi]
serial: /tmp/klipper_host_mcu

[adxl345]
cs_pin: rpi:None
spi_speed: 2000000
spi_bus: spidev2.0

[resonance_tester]
accel_chip: adxl345
accel_per_hz: 70
probe_points:
      117.5,117.5,10
```
> Use whatever probe points are appropriate for your bed size

You can now use the accelerometer to measure resonance. If you run into errors when not using the accelerometer, comment out the lines above and uncomment when a measurement is needed.

-----

# Troubleshooting:

Some users have reported the following error while trying to flash klipper-mcu:

```
sonic@SonicPad:~/klipper$ make menuconfig #
Loaded configuration '/home/sonic/klipper/.config'
Traceback (most recent call last):
  File "/home/sonic/klipper/lib/kconfiglib/menuconfig.py", line 3281, in <module>
    _main()
  File "/home/sonic/klipper/lib/kconfiglib/menuconfig.py", line 661, in _main
    menuconfig(standard_kconfig(__doc__))
  File "/home/sonic/klipper/lib/kconfiglib/menuconfig.py", line 705, in menuconfig
    locale.setlocale(locale.LC_ALL, "")
  File "/usr/lib/python3.9/locale.py", line 610, in setlocale
    return _setlocale(category, locale)
locale.Error: unsupported locale setting
make: *** [Makefile:116: menuconfig] Error 1
```

To remedy, run the following commands and select "en_US UTF8"

```
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
sudo dpkg-reconfigure locales
```
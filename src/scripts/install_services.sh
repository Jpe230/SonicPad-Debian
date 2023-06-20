#!/bin/bash

set -e

INSTALLER_DIR="$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}")")"
SYSTEMD="/etc/systemd/system"
USER=$(whoami)

echo "Fixing permissions"
sudo chown -R $USER /home/$USER

echo "Adding hostname to hosts"
sudo -- sh -c "echo '127.0.1.1 SonicPad' >> /etc/hosts"

source ./install_klipper.sh
source ./install_moonraker.sh
source ./install_klipperscreen.sh

echo "Installing Klipper"
install_klipper

echo "Installing Moonraker"
install_moonraker

echo "Installing Klipperscreen"
install_klipperscreen

echo "Enabling depmod service"
sudo chmod +x /usr/local/bin/depmod_enable.sh
sudo systemctl enable depmod_boot

echo "Enabling expandfs"
sudo chmod +x /usr/local/bin/expandfs_enable.sh
sudo systemctl enable expandfs

echo "Enabling LED EMMC"
sudo chmod +x /usr/local/bin/ledmmc_enable.sh
sudo systemctl enable ledmmc

echo "Enabling USB Host"
sudo chmod +x /usr/local/bin/usbhost_enable.sh
sudo systemctl enable usbhost

# echo "Running depmod"
# sudo depmod 4.9.191

echo "Fixing networking..."
sudo -- sh -c "echo 'ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev' > /etc/wpa_supplicant/wpa_supplicant.conf"
sudo usermod -aG netdev $USER

echo "Compiling brightness..."
cd /home/$USER/scripts/resources/brightness
gcc -o brightness brightness.c
sudo mv brightness /bin/brightness

echo "Cleaning up cache"
sudo apt clean
sudo rm -rf /var/cache/apt/
sudo rm -rf ~/.cache

echo "Fixing permissions"
sudo chown -R $USER /home/$USER

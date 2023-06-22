#!/bin/bash
# Copyright (C) 2020 - 2023 Dominik Willner <th33xitus@gmail.com>
# Adapted by Jpe230 for a headless install

set -e

source ./klipper.config
source ./klipperscreen.config

function klipperscreen_setup() {
    local branch="sonic_pad"
    if git clone "${KLIPPERSCREEN_REPO}" "${KLIPPERSCREEN_DIR}"; then
        cd "${KLIPPERSCREEN_DIR}" && git checkout "${branch}"
    else
        echo "Cloning Klipper from\n ${KLIPPERSCREEN_REPO}\n failed!"
        exit 1
    fi

    patched_installer="${INSTALLER_DIR}/resources/KlipperScreen_install-no-start.sh"
    sudo chmod +x $patched_installer
    cp $patched_installer "${KLIPPERSCREEN_DIR}"/scripts/

    if "${KLIPPERSCREEN_DIR}"/scripts/KlipperScreen_install-no-start.sh; then
        echo "KlipperScreen successfully installed!"
        rm "${KLIPPERSCREEN_DIR}"/scripts/KlipperScreen_install-no-start.sh
    else
        echo "KlipperScreen installation failed!"
        rm "${KLIPPERSCREEN_DIR}"/scripts/KlipperScreen_install-no-start.sh
        exit 1
    fi
}

function patch_klipperscreen_update_manager()
{
    local moonraker_configs
    moonraker_configs=$(find "${KLIPPER_CONFIG}" -type f -name "moonraker.conf" | sort)
    for conf in ${moonraker_configs}; do
        if ! grep -Eq "^\[update_manager KlipperScreen\]\s*$" "${conf}"; then
            ### add KlipperScreens update manager section to moonraker.conf
            echo "Adding KlipperScreen to update manager in file:\n       ${conf}"
            echo "" >> $conf
            echo "" >> $conf
            echo "[update_manager KlipperScreen]" >> $conf
            echo "type: git_repo" >> $conf
            echo "path: ${HOME}/KlipperScreen" >> $conf
            echo "primary_branch:: sonic_pad" >> $conf
            echo "origin: ${KLIPPERSCREEN_REPO}" >> $conf
            echo "env: ${HOME}/.KlipperScreen-env/bin/python" >> $conf
            echo "requirements: scripts/KlipperScreen-requirements.txt" >> $conf
            echo "install_script: scripts/KlipperScreen-install.sh" >> $conf
        fi
    done
}

function configure_xorg_fb()
{
    echo "Copying xorg conf"
    xorgconf="${INSTALLER_DIR}/resources/xorg.conf"
    sudo cp $xorgconf /etc/X11/
}

function install_klipperscreen()
{
    # 1) Install KlipperScreen
    klipperscreen_setup

    # 2) Patch Update Manager
    patch_klipperscreen_update_manager

    # 3) Configure display
    configure_xorg_fb

    # 3) Fix permissions
    sudo bash -c "echo needs_root_rights=yes>>/etc/X11/Xwrapper.config"
}


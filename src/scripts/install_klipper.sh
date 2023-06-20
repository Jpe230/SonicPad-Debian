#!/bin/bash
# Copyright (C) 2020 - 2023 Dominik Willner <th33xitus@gmail.com>
# Adapted by Jpe230 for a headless install

set -e

source ./klipper.config

function clone_kliper_repo()
{
    local branch="master"
    if git clone "${KLIPPER_REPO}" "${KLIPPER_DIR}"; then
        cd "${KLIPPER_DIR}" && git checkout "${branch}"
    else
        echo "Cloning Klipper from\n ${repo}\n failed!"
        exit 1
    fi
}

function install_klipper_packages()
{   
    sudo apt-get update --allow-releaseinfo-change
    sudo apt-get install --yes $PKGLIST
}

function create_klipper_env()
{
    if virtualenv -p "python3" "${KLIPPY_ENV}"; then
        "${KLIPPY_ENV}"/bin/pip install -U pip
        "${KLIPPY_ENV}"/bin/pip install -r "${KLIPPER_DIR}"/scripts/klippy-requirements.txt
    else
        echo "Error creating venv for klipper"
    fi
}

function create_required_folders()
{
    local printer_data=${1} folders
    folders=("backup" "certs" "config" "database" "gcodes" "comms" "logs" "systemd")

    for folder in "${folders[@]}"; do
        local dir="${printer_data}/${folder}"

        ### remove possible symlink created by moonraker
        if [[ -L "${dir}" && -d "${dir}" ]]; then
        rm "${dir}"
        fi

        if [[ ! -d "${dir}" ]]; then
        mkdir -p "${dir}"
        fi
    done
}

function write_example_printer_cfg()
{
    local cfg=${1}
    local cfg_template

    cfg_template="${INSTALLER_DIR}/resources/example.printer.cfg"

    echo "Creating minimal example printer.cfg ..."
    if cp "${cfg_template}" "${cfg}"; then
        echo "Minimal example printer.cfg created!"
    else
        echo "Couldn't create minimal example printer.cfg!"
    fi
}

function create_klipper_service()
{
    local instance_name=${1}
    local printer_data
    local cfg_dir
    local cfg
    local log
    local klippy_serial
    local klippy_socket
    local env_file
    local service
    local service_template
    local env_template
    local suffix

    printer_data="${HOME}/${instance_name}_data"
    cfg_dir="${printer_data}/config"
    cfg="${cfg_dir}/printer.cfg"
    log="${printer_data}/logs/klippy.log"
    klippy_serial="${printer_data}/comms/klippy.serial"
    klippy_socket="${printer_data}/comms/klippy.sock"
    env_file="${printer_data}/systemd/klipper.env"

    if [[ ${instance_name} == "printer" ]]; then
        suffix="${instance_name//printer/}"
    else
        suffix="-${instance_name//printer_/}"
    fi

    create_required_folders "${printer_data}"

    service_template="${INSTALLER_DIR}/resources/klipper.service"
    env_template="${INSTALLER_DIR}/resources/klipper.env"
    service="${SYSTEMD}/klipper${suffix}.service"

    echo "Create Klipper service file ..."
    sudo cp "${service_template}" "${service}"
    sudo cp "${env_template}" "${env_file}"
    sudo sed -i "s|%USER%|${USER}|g; s|%ENV%|${KLIPPY_ENV}|; s|%ENV_FILE%|${env_file}|" "${service}"
    sudo sed -i "s|%USER%|${USER}|; s|%LOG%|${log}|; s|%CFG%|${cfg}|; s|%PRINTER%|${klippy_serial}|; s|%UDS%|${klippy_socket}|" "${env_file}"
    echo "Klipper service file created!"

    write_example_printer_cfg "${cfg}"
}


function install_klipper()
{
    # 1) Clone Klipper repo
    clone_kliper_repo

    # 2) Install pkgs
    install_klipper_packages

    # 3) Create env
    create_klipper_env

    # 4) Create klipper service
    create_klipper_service printer

    # 5) Enable service
    sudo systemctl enable klipper 
}
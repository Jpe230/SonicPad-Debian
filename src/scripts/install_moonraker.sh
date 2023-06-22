#!/bin/bash
# Copyright (C) 2020 - 2023 Dominik Willner <th33xitus@gmail.com>
# Adapted by Jpe230 for a headless install

set -e 

source ./moonraker.config

function clone_moonraker_repo()
{
    local branch="master"
    if git clone "${MOONRAKER_REPO}" "${MOONRAKER_DIR}"; then
        cd "${MOONRAKER_DIR}" && git checkout "${branch}"
    else
        echo "Cloning Moonraker from\n ${MOONRAKER_REPO}\n failed!"
        exit 1
    fi
}

function install_moonraker_packages()
{   
    sudo apt-get update --allow-releaseinfo-change
    sudo apt-get install --yes $MOONRAKER_PKGLIST
}

function create_moonraker_env()
{
    if virtualenv -p "python3" "${MOONRAKER_ENV}"; then
        "${MOONRAKER_ENV}"/bin/pip install -U pip
        "${MOONRAKER_ENV}"/bin/pip install -r "${MOONRAKER_DIR}/scripts/moonraker-requirements.txt"
    else
        echo "Error creating venv for moonraker"
    fi
}

function create_moonraker_conf()
{
    local port lan printer_data cfg_dir cfg uds

    port=7125
    lan="$(hostname -I | cut -d" " -f1 | cut -d"." -f1-2).0.0/16"

    printer_data="${HOME}/printer_data"
    cfg_dir="${printer_data}/config"
    cfg="${cfg_dir}/moonraker.conf"
    uds="${printer_data}/comms/klippy.sock"

    ### write single instance config
    write_moonraker_conf "${cfg_dir}" "${cfg}" "${port}" "${uds}" "${lan}"
}

function write_moonraker_conf()
{
    local cfg_dir=${1} cfg=${2} port=${3} uds=${4} lan=${5}
    local conf_template="${INSTALLER_DIR}/resources/moonraker.conf"

    echo "Creating moonraker.conf in ${cfg_dir} ..."
    cp "${conf_template}" "${cfg}"
    sed -i "s|%USER%|${USER}|g; s|%PORT%|${port}|; s|%UDS%|${uds}|" "${cfg}"
    # if host ip is not in the default ip ranges replace placeholder,
    # otherwise remove placeholder from config
    if ! grep -q "${lan}" "${cfg}"; then
        sed -i "s|%LAN%|${lan}|" "${cfg}"
    else
        sed -i "/%LAN%/d" "${cfg}"
    fi
    echo "moonraker.conf created!"
}

function write_moonraker_service()
{
    local i=${1} printer_data=${2} service=${3} env_file=${4}
    local service_template="${INSTALLER_DIR}/resources/moonraker.service"
    local env_template="${INSTALLER_DIR}/resources/moonraker.env"

    echo "Creating Moonraker Service ${i} ..."
    sudo cp "${service_template}" "${service}"
    sudo cp "${env_template}" "${env_file}"

    [[ -z ${i} ]] && sudo sed -i "s| %INST%||" "${service}"
    [[ -n ${i} ]] && sudo sed -i "s|%INST%|${i}|" "${service}"

    sudo sed -i "s|%USER%|${USER}|g; s|%ENV%|${MOONRAKER_ENV}|; s|%ENV_FILE%|${env_file}|" "${service}"
    sudo sed -i "s|%USER%|${USER}|; s|%PRINTER_DATA%|${printer_data}|" "${env_file}"
}

function configure_moonraker_service()
{
    local cfg_dir service env_file
   
    printer_data="${HOME}/printer_data"
    cfg_dir="${printer_data}/config"
    service="${SYSTEMD}/moonraker.service"
    env_file="${printer_data}/systemd/moonraker.env"

    ### write single instance service
    write_moonraker_service "" "${printer_data}" "${service}" "${env_file}"
    echo "Moonraker instance created!"
}

function install_moonraker_polkit() {
  "${HOME}"/moonraker/scripts/set-policykit-rules.sh --disable-systemctl
}

function install_moonraker()
{
    # 1) Clone Klipper repo
    clone_moonraker_repo

    # 2) Install pkgs
    install_moonraker_packages

    # 3) Create env
    create_moonraker_env

    # 4) Create moonraker conf
    create_moonraker_conf

    # 4) Create moonraker service
    configure_moonraker_service

    # 5) Install moonraker pollkit
    install_moonraker_polkit

    # 6) Enable service
    sudo systemctl enable moonraker 

    sudo usermod -aG dialout $USER
}
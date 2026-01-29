#!/usr/bin/env bash

set -Eeuo pipefail

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

readonly PACKAGES=(
    openssh-client
)

function install_openssh() {
    apt_safe_install "${PACKAGES[@]}"
}

function uninstall_openssh() {
    apt_safe_remove "${PACKAGES[@]}"
}

function main() {
    install_openssh
}

if [ ${#BASH_SOURCE[@]} = 1 ]; then
    main
fi

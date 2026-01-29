#!/usr/bin/env bash

set -Eeuo pipefail

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

readonly PACKAGES=(
    tmux
    # git
    xsel
    cmake
)

function install_tmux() {
    apt_safe_install "${PACKAGES[@]}"
}

function uninstall_tmux() {
    apt_safe_remove "${PACKAGES[@]}"
}

function main() {
    install_tmux
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi

#!/usr/bin/env bash

# Function to check if a package is installed
function is_installed() {
    dpkg -s "$1" &> /dev/null
}

# Safe install function
function apt_safe_install() {
    local packages=("$@")
    local missing_packages=()

    for pkg in "${packages[@]}"; do
        if ! is_installed "$pkg"; then
            missing_packages+=("$pkg")
        fi
    done

    if [ ${#missing_packages[@]} -eq 0 ]; then
        echo "All packages already installed: ${packages[*]}"
        return 0
    fi

    echo "Attempting to install: ${missing_packages[*]}"

    if [ "$EUID" -eq 0 ]; then
        apt-get install -y "${missing_packages[@]}"
    else
        # Try non-interactive sudo
        if ! sudo -n apt-get install -y "${missing_packages[@]}"; then
             echo "Sudo not available. Falling back to static binaries..."
             
             for pkg in "${missing_packages[@]}"; do
                 install_static_fallback "$pkg"
             done
        fi
    fi
}

function install_static_fallback() {
    local pkg="$1"
    local bindir="${HOME}/.local/bin"
    mkdir -p "$bindir"
    export PATH="$bindir:$PATH"

    case "$pkg" in
        busybox)
            if ! command -v busybox >/dev/null 2>&1; then
                echo "Installing busybox static binary..."
                curl -fsSL -o "$bindir/busybox" "https://busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-x86_64"
                chmod +x "$bindir/busybox"
            fi
            ;;
        zsh)
            if ! command -v zsh >/dev/null 2>&1; then
                echo "Installing zsh via zsh-bin (static)..."
                # Using romkatv/zsh-bin
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh-bin/master/install)" -- \
                    -d "${HOME}/.local" -e no
            fi
            ;;
        tmux)
            if ! command -v tmux >/dev/null 2>&1; then
                echo "Installing tmux via static build..."
                # Download tmux static binary (latest stable typically) or appimage
                # Using a known reliable static build for x86_64
                curl -fsSL -o "$bindir/tmux" https://github.com/nelsonenzo/tmux-appimage/releases/download/3.3a/tmux.appimage
                chmod +x "$bindir/tmux"
            fi
            ;;
        cmake)
            if ! command -v cmake >/dev/null 2>&1; then
                echo "Installing cmake static binary..."
                # Simplified download for linux x86_64
                local ver="3.31.5"
                curl -fsSL https://github.com/Kitware/CMake/releases/download/v${ver}/cmake-${ver}-linux-x86_64.tar.gz | \
                tar -xz -C "${HOME}/.local" --strip-components=1
            fi
            ;;
        *)
            echo "Warning: No static binary fallback for '$pkg'. Skipping."
            ;;
    esac
}

# Safe remove function
function apt_safe_remove() {
    local packages=("$@")
    
    if [ "$EUID" -eq 0 ]; then
        apt-get remove -y "${packages[@]}"
    else
        if ! sudo -n apt-get remove -y "${packages[@]}"; then
            echo "Warning: Failed to remove packages (sudo -n denied). Skipping: ${packages[*]}"
        fi
    fi
}

# Safe update function
function apt_safe_update() {
    if [ "$EUID" -eq 0 ]; then
        apt-get update
    else
        if ! sudo -n apt-get update; then
            echo "Warning: Failed to update apt (sudo -n denied). Skipping."
        fi
    fi
}

# Safe run with sudo
function sudo_safe_run() {
    if [ "$EUID" -eq 0 ]; then
        "$@"
    else
        if ! sudo -n "$@"; then
             echo "Warning: Failed to run command with sudo -n. Skipping: $*"
        fi
    fi
}

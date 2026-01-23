#!/usr/bin/env bash

set -Eeuo pipefail

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

# shellcheck disable=SC2016
declare -r DOTFILES_LOGO='
                          /$$                                      /$$
                         | $$                                     | $$
     /$$$$$$$  /$$$$$$  /$$$$$$   /$$   /$$  /$$$$$$      /$$$$$$$| $$$$$$$
    /$$_____/ /$$__  $$|_  $$_/  | $$  | $$ /$$__  $$    /$$_____/| $$__  $$
   |  $$$$$$ | $$$$$$$$  | $$    | $$  | $$| $$  \ $$   |  $$$$$$ | $$  \ $$
    \____  $$| $$_____/  | $$ /$$| $$  | $$| $$  | $$\    \____  $$| $$  | $$
    /$$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$/| $$$$$$$//$$ /$$$$$$$/| $$  | $$
   |_______/  \_______/   \___/   \______/ | $$____/|__/|_______/ |__/  |__/
                                           | $$
                                           | $$
                                           |__/

             *** This is setup script for my dotfiles setup ***            
                     https://github.com/nrtkKodama/dotfiles
'

# ==============================================================================
# Configuration Loading
# ==============================================================================

# Try to load config.env if it exists locally
if [ -n "${BASH_SOURCE[0]:-}" ]; then
    CONFIG_FILE="$(dirname "${BASH_SOURCE[0]}")/config.env"
    if [ -f "$CONFIG_FILE" ]; then
        # shellcheck disable=SC1090
        source "$CONFIG_FILE"
    fi
fi

# Set defaults if variables are not set (e.g., when running via curl)
# These defaults align with the values in config.env.template
: "${GITHUB_USER:=nrtkKodama}"
: "${DOTFILES_REPO_NAME:=dotfiles}"
: "${DOTFILES_BRANCH:=main}"
: "${PRIVATE_DOTFILES_REPO_NAME:=dotfiles-private}"

# Construct URLs and Paths based on variables
# If running inside the repo (e.g., cloned locally), use the local path.
# Otherwise, default to GitHub URL.
if [ -d "${BASH_SOURCE[0]%/*}/.git" ]; then
    DEFAULT_REPO_URL="$(cd "${BASH_SOURCE[0]%/*}" && pwd)"
else
    DEFAULT_REPO_URL="https://github.com/${GITHUB_USER}/${DOTFILES_REPO_NAME}"
fi

: "${DOTFILES_REPO_URL:=${DEFAULT_REPO_URL}}"
declare -r BRANCH_NAME="${DOTFILES_BRANCH}"

declare -r PRIVATE_DOTFILES_REPO_URL="https://github.com/${GITHUB_USER}/${PRIVATE_DOTFILES_REPO_NAME}"
declare -r PRIVATE_DOTFILES_PATH="${HOME}/.local/share/chezmoi-private"
declare -r PRIVATE_DOTFILES_CONFIG_PATH="${HOME}/.config/chezmoi-private/chezmoi.yaml"

# ==============================================================================
# Utility Functions
# ==============================================================================

function is_ci() {
    "${CI:-false}"
}

function is_tty() {
    [ -t 0 ]
}

function is_not_tty() {
    ! is_tty
}

function is_ci_or_not_tty() {
    is_ci || is_not_tty
}

function get_os_type() {
    uname
}

function initialize_os_macos() {
    function is_homebrew_exists() {
        command -v brew &>/dev/null
    }

    # Instal Homebrew if needed.
    if ! is_homebrew_exists; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Setup Homebrew envvars.
    if [[ $(arch) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ $(arch) == "i386" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    else
        echo "Invalid CPU arch: $(arch)" >&2
        exit 1
    fi
}

function initialize_os_linux() {
    :
}

function initialize_os_env() {
    local ostype
    ostype="$(get_os_type)"

    if [ "${ostype}" == "Darwin" ]; then
        initialize_os_macos
    elif [ "${ostype}" == "Linux" ]; then
        initialize_os_linux
    else
        echo "Invalid OS type: ${ostype}" >&2
        exit 1
    fi
}

function run_chezmoi() {
    local bin_dir="${HOME}/.local/bin"
    export PATH="${PATH}:${bin_dir}"

    # download the chezmoi binary from the URL
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "${bin_dir}"
    local chezmoi_cmd="${bin_dir}/chezmoi"

    if is_ci_or_not_tty; then
        no_tty_option="--no-tty" # /dev/tty is not available (especially in the CI)
    else
        no_tty_option="" # /dev/tty is available OR not in the CI
    fi
    # run `chezmoi init` to setup the source directory,
    # generate the config file, and optionally update the destination directory
    # to match the target state.
    "${chezmoi_cmd}" init "${DOTFILES_REPO_URL}" \
        --force \
        --branch "${BRANCH_NAME}" \
        --use-builtin-git true \
        ${no_tty_option}

    # the `age` command requires a tty, but there is no tty in the github actions.
    # Therefore, it is currnetly difficult to decrypt the files encrypted with `age` in this workflow.
    # I decided to temporarily remove the encrypted target files from chezmoi's control.
    if is_ci_or_not_tty; then
        find "$(${chezmoi_cmd} source-path)" -type f -name "encrypted_*" -exec rm -fv {} +
    fi

    # Add to PATH for installing the necessary binary files under `$HOME/.local/bin`.
    export PATH="${PATH}:${HOME}/.local/bin"

    # run `chezmoi apply` to ensure that target... are in the target state,
    # updating them if necessary.
    "${chezmoi_cmd}" apply ${no_tty_option}

    # run `chezmoi init` for private dotfiles
    # Note: If `--config ~/.config/chezmoi/chezmoi.yaml` is not specified, it seems to use the same config file as the public dotfiles.
    "${chezmoi_cmd}" init \
        --apply \
        --ssh \
        --source "${PRIVATE_DOTFILES_PATH}" \
        --config "${PRIVATE_DOTFILES_CONFIG_PATH}" \
        "${PRIVATE_DOTFILES_REPO_URL}"

    # purge the binary of the chezmoi cmd
    rm -fv "${chezmoi_cmd}"
}

function initialize_dotfiles() {
    run_chezmoi
}

function get_system_from_chezmoi() {
    local system
    system=$(chezmoi data | jq -r '.system')
    echo "${system}"
}

function restart_shell_system() {
    local system
    system=$(get_system_from_chezmoi)

    # exec shell as login shell (to reload the .zprofile or .profile)
    if [ "${system}" == "client" ]; then
        /bin/zsh --login

    elif [ "${system}" == "server" ]; then
        /bin/bash --login

    else
        echo "Invalid system: ${system}; expected \`client\` or \`server\`" >&2
        exit 1
    fi
}

function restart_shell() {

    # Restart shell if specified "bash -c $(curl -L {URL})"
    # not restart:
    #   curl -L {URL} | bash
    if [ -p /dev/stdin ]; then
        echo "Now continue with Rebooting your shell"
    else
        echo "Restarting your shell..."
        restart_shell_system
    fi
}

function main() {
    echo "${DOTFILES_LOGO}"

    initialize_os_env
    initialize_dotfiles

    # restart_shell # Disabled because the at_exit function does not work properly.
}

main

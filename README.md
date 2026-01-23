<div align="center">
    <img src="./.github/header.png" alt="shunk031's">
    <h1>📂 dotfiles</h1>
</div>

<div align="center">

[![Snippet install](https://github.com/nrtkKodama/dotfiles/actions/workflows/remote.yaml/badge.svg)](https://github.com/nrtkKodama/dotfiles/actions/workflows/remote.yaml)
[![Unit test](https://github.com/nrtkKodama/dotfiles/actions/workflows/test.yaml/badge.svg)](https://github.com/nrtkKodama/dotfiles/actions/workflows/test.yaml)
[![codecov](https://codecov.io/gh/nrtkKodama/dotfiles/graph/badge.svg?token=4VUJWKGAR7)](https://codecov.io/gh/nrtkKodama/dotfiles)

[![zsh-users/zsh](https://img.shields.io/github/v/tag/zsh-users/zsh?color=2885F1&display_name=release&label=zsh&logo=zsh&logoColor=2885F1&sort=semver)](https://github.com/zsh-users/zsh)
[![tmux/tmux](https://img.shields.io/github/v/tag/tmux/tmux?color=1BB91F&display_name=release&label=tmux&logo=tmux&logoColor=1BB91F&sort=semver)](https://github.com/tmux/tmux)
[![rossmacarthur/sheldon](https://img.shields.io/github/v/tag/rossmacarthur/sheldon?color=282d3f&display_name=release&label=🚀%20sheldon&sort=semver)](https://github.com/rossmacarthur/sheldon)
[![starship/starship](https://img.shields.io/github/v/tag/starship/starship?color=DD0B78&display_name=release&label=starship&logo=starship&logoColor=DD0B78&sort=semver)](https://github.com/starship/starship)
[![jdx/mise](https://img.shields.io/github/v/tag/jdx/mise?color=00acc1&display_name=release&label=mise&logo=gnometerminal&logoColor=00acc1&sort=semver)](https://github.com/jdx/mise)
[![anthropics/claude-code](https://img.shields.io/github/v/tag/anthropics/claude-code?color=D97757&display_name=release&label=claude-code&logo=claude&logoColor=D97757&sort=semver)](https://github.com/anthropics/claude-code)

</div>

## 🗿 Overview

This [dotfiles](https://github.com/nrtkKodama/dotfiles) repository is managed with [`chezmoi🏠`](https://www.chezmoi.io/), a great dotfiles manager.
The setup scripts are aimed for [MacOS](https://www.apple.com/jp/macos), [Ubuntu Desktop](https://ubuntu.com/desktop), and [Ubuntu Server](https://ubuntu.com/server).

The actual dotfiles exist under the [`home`](https://github.com/nrtkKodama/dotfiles/tree/master/home) directory specified in the [`.chezmoiroot`](https://github.com/nrtkKodama/dotfiles/blob/master/.chezmoiroot).

## 📋 Prerequisites

Ensure the following tools are installed on your system before running the setup:

*   `curl` (for downloading the setup script)
*   `git` (optional, but recommended)

## 📥 Setup (Fresh Install)

To set up the dotfiles on a new machine, run the following command.
This script will detect your environment, install `chezmoi`, and prompt you for necessary configuration (email, git username, etc.).

### 💻 `MacOS` / 🖥️ `Ubuntu`

```bash
bash -c "$(curl -fsLS https://raw.githubusercontent.com/nrtkKodama/dotfiles/main/setup.sh)"
```

### ⚙️ Interactive Configuration

During the setup process (`chezmoi init`), you will be prompted for:

1.  **Email address**: Used for Git configuration.
2.  **System**: `client` (desktop with GUI) or `server` (headless).
3.  **Git Name**: Your name for Git commits (e.g., "John Doe").
4.  **Git Signing Key**: (Optional) GPG key ID for signing commits.

*Note: The setup script defaults to using your local username as the GitHub owner. If you are using a fork or a different GitHub account, override it like this:*

```bash
export GITHUB_USER="nrtkKodama"
bash -c "$(curl -fsLS https://raw.githubusercontent.com/${GITHUB_USER}/dotfiles/main/setup.sh)"
```

### Minimal setup

The following is a minimal setup command to install chezmoi and my dotfiles from the github repository on a new empty machine:

> sh -c "$(curl -fsLS get.chezmoi.io)" -- init nrtkKodama --apply

### 🔒 Secrets Management

This repository is designed to be public, but your secrets (API keys, SSH keys) must remain private.
**We provide a strict guide and tools to prevent accidental leaks.**

*   **Read the Guide**: [docs/SECRETS_MANAGEMENT.md](docs/SECRETS_MANAGEMENT.md)
*   **Safety Check**: Run `./scripts/check_secrets.sh` to scan for potential leaks.
*   **Encryption**: Use `chezmoi`'s built-in age encryption for sensitive files.

## 🐍 Reproducible Environments

This repository includes setup for reproducible development environments using **Docker** or **Singularity**.

### Python Environment (`environments/python`)
A consistent Python development environment with `uv`, optimized for both root and rootless usage.

*   **Docker**: Standard containerization.
*   **Singularity**: Ideal for HPC or shared servers where you don't have root access.

```bash
cd environments/python

# Docker
make up
make exec

# Singularity (Rootless)
make singularity-build  # Builds .sif image
make singularity-shell  # Enters the container
```

## 🛠️ Update & Maintenance

Updating and testing the dotfiles follows [chezmoi's daily operations](https://www.chezmoi.io/user-guide/daily-operations/).

```bash
# Apply changes
chezmoi apply

# Update from remote
chezmoi update
```

## 📊 Stats

![Alt](https://repobeats.axiom.co/api/embed/3243fb1d3b6ca001788079f0b888dde30d9d2df1.svg "Repobeats analytics image")

## 📝 License

The code is available under the [MIT license](https://github.com/nrtkKodama/dotfiles/blob/master/LICENSE).
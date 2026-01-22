# Gemini Context: Dotfiles Project

## Project Overview

This repository contains dotfiles managed by [chezmoi](https://www.chezmoi.io/), designed for **macOS** and **Ubuntu** (Desktop/Client and Server).

*   **Manager:** `chezmoi`
*   **Target Systems:** macOS (Apple Silicon/Intel), Ubuntu (Client/Server)
*   **Key Components:**
    *   **Shell:** `zsh` (with `starship`, `sheldon` for plugins)
    *   **Terminal Multiplexer:** `tmux`
    *   **Tool Version Manager:** `mise`
    *   **Editors:** `vim`, `spacemacs` configuration
    *   **AI/Tools:** `claude`, `git` configuration

## Directory Structure

*   `home/`: The source state for `chezmoi`. Contains the dotfiles and templates.
    *   `.chezmoiscripts/`: Scripts that run during `chezmoi apply` (e.g., `run_once_...`).
*   `install/`: Raw shell scripts for installing applications and setting up environments. These are often included by the templates in `home/.chezmoiscripts/`.
*   `tests/`: Unit tests using [Bats](https://github.com/bats-core/bats-core).
*   `.github/workflows/`: CI/CD pipelines for testing on macOS and Ubuntu.
*   `setup.sh`: The main bootstrapping script.

## Setup & Usage

### Bootstrapping
To set up the environment on a new machine:

**macOS:**
```bash
bash -c "$(curl -fsLS https://raw.githubusercontent.com/nrtkKodama/dotfiles/main/setup.sh)"
```

**Ubuntu:**
```bash
bash -c "$(wget -qO - https://raw.githubusercontent.com/nrtkKodama/dotfiles/main/setup.sh)"
```

### Development & Testing
*   **Run in Docker (Test Environment):**
    ```bash
    make docker
    ```
    This builds a Docker image and drops you into a shell to test the dotfiles safely.

*   **Watch Mode:**
    ```bash
    make watch
    ```
    Uses `watchexec` to apply `chezmoi` changes automatically when files are modified.

*   **Run Unit Tests:**
    ```bash
    ./scripts/run_unit_test.sh
    ```
    Requires `bats` and `kcov` (for coverage).

## Development Conventions

*   **Installation Logic:**
    1.  Write the raw installation shell script in `install/<os>/<category>/<script>.sh`.
    2.  Create a corresponding `chezmoi` template in `home/.chezmoiscripts/<os>/run_once_<number>-<name>.sh.tmpl`.
    3.  Use `{{ include "../install/..." }}` within the template to include the raw script.

*   **Testing:**
    *   Tests are written in Bats and located in `tests/files/`.
    *   CI runs tests on both Ubuntu and macOS runners.
    *   Code coverage is tracked via Codecov.

*   **Chezmoi Structure:**
    *   `dot_` prefix means a dotfile (e.g., `dot_zshrc` -> `.zshrc`).
    *   `run_once_` scripts execute only when their content changes (or hash changes).

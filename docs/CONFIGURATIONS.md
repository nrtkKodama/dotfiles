# Tool Configurations

This document details the configuration of key tools managed by this dotfiles repository.

## 🖥️ Tmux

The `tmux` configuration is designed to work across **macOS**, **Ubuntu Desktop (Client)**, and **Ubuntu Server**. It is split into modular files to handle system differences.

*   **Config Source:** `home/dot_tmux.conf.tmpl`
*   **Modular Configs:** `home/dot_tmux.conf.d/`

### Prefix Key

The prefix key is unified to `C-b` across all environments.

| Key | Action |
| :--- | :--- |
| `C-b` | Default Prefix |

### Keybindings

| Key | Action | Context |
| :--- | :--- | :--- |
| `1` | Break Pane | All |
| `c` | New Window | Current Path (Client Only) |
| `2` | Split Window Vertically | Current Path |
| `3` | Split Window Horizontally | Current Path |
| `C-p` | Select Pane Up | Client Only |
| `C-n` | Select Pane Down | Client Only |
| `C-r` | Reload Config | All |
| `C-k` | Kill Pane | All |
| `k` | Kill Window | All |
| `^[`, `^]` | Copy/Paste Mode | Emacs Style (Client Only) |

### Plugins (Client)
*   **[tmux-powerline](https://github.com/shunk031/tmux-powerline)**: Status bar styling.
*   **[tpm](https://github.com/tmux-plugins/tpm)**: Plugin manager.
*   **[tmux-prefix-highlight](https://github.com/tmux-plugins/tmux-prefix-highlight)**: Shows when prefix is active.

### OS-Specifics
*   **macOS**: Configured with `reattach-to-user-namespace pbcopy` for clipboard sharing. Enables `allow-passthrough` for Touch ID sudo.
*   **Ubuntu**: Configured with `xsel -bi` for clipboard sharing.

---

## 🐚 Zsh

The `zsh` configuration relies heavily on modern plugin managers and prompts.

*   **Config Source:** `home/dot_zshrc`
*   **Plugin Manager:** [Sheldon](https://github.com/rossmacarthur/sheldon)
    *   Config: `home/dot_config/sheldon/plugins.toml.tmpl`
*   **Prompt:** [Starship](https://starship.rs/)
    *   Config: `home/dot_config/starship.toml`

---

## 🔧 Mise (Tool Management)

[Mise](https://github.com/jdx/mise) (formerly rtx) is used to manage runtime versions (Node.js, Python, etc.).

*   **Config:** `home/dot_config/mise/config.toml`

---

## 📝 Vim

A minimal `vim` configuration is provided for basic editing needs.

*   **Config Source:** `home/dot_vimrc`
*   **Settings:** Syntax highlighting, line numbers, smart indent, 4-space tabs (expanded).

# Secrets Management & Security Guide

This repository is designed to be public, but your personal secrets (API keys, SSH keys, passwords) must remain private.
This guide explains the design choices and safety mechanisms in place.

## ⚠️ Critical Files & Directories

The following locations are high-risk for accidental secret exposure. **Never commit unencrypted files in these paths:**

| Path | Description | Protection Mechanism |
|------|-------------|----------------------|
| `home/private_dot_ssh/` | SSH keys and config | Should be **encrypted** with `chezmoi` (age) |
| `home/private_dot_gnupg/` | GPG keys and config | Should be **encrypted** with `chezmoi` (age) |
| `config.env` | User-specific setup vars | Ignored by `.gitignore` |
| `home/dot_config/gemini/` | AI CLI Config | Check for API keys before committing |
| `home/dot_config/claude/` | Claude Config | Check for API keys before committing |
| `home/dot_netrc`, `home/_netrc` | Network credentials | Should be encrypted or ignored |

## 🔒 Encryption with `age`

We use `chezmoi`'s built-in encryption with `age`.
**Any file starting with `encrypted_` is safe to commit.**
**Any file starting with `private_` but NOT `encrypted_` is DANGEROUS to commit if it contains secrets.**

### How to Encrypt a File
To safely track a sensitive file (e.g., `~/.ssh/id_ed25519`):

```bash
chezmoi add --encrypt ~/.ssh/id_ed25519
```

This creates `home/private_dot_ssh/encrypted_id_ed25519.age`.

## 🛡️ Safety Checks

### 1. `.gitignore` & `.chezmoiignore`
We explicitly ignore common credential files.
*   `config.env`: Contains local setup variables.
*   `*.key`: Generic key files.

### 2. Pre-Commit Verification (Manual)
Before pushing to your dotfiles repository, always run:

```bash
chezmoi status
```

If you see modifications in `private_` files that are NOT `encrypted_`, **STOP** and verify.

## 🚨 If You Accidentally Commit a Secret

1.  **Rotate the key immediately.** Consider it compromised.
2.  Remove the file from git history (e.g., using `git filter-repo` or `BFG Repo-Cleaner`).
3.  Force push the clean history.

## Recommended: Use a Password Manager
For API keys in dotfiles, prefer using a password manager command-line tool (like `op` for 1Password) to inject secrets at runtime, rather than storing them in files.

Example in a template:
```
{{ (bitwarden "item" "my-api-key").notes }}
```

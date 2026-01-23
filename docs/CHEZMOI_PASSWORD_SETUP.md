# Chezmoi Password & Encryption Setup

This guide explains how to set up encryption for your dotfiles using `chezmoi` and `age`.
This allows you to securely manage sensitive files like SSH keys, API tokens, and passwords within your public dotfiles repository.

## Prerequisites

- **age**: A simple, modern, and secure file encryption tool.
- **chezmoi**: Your dotfiles manager (already installed).

### Install `age`

**macOS (Homebrew):**
```bash
brew install age
```

**Ubuntu:**
```bash
sudo apt install age
```

---

## 1. Generate an Encryption Key

Generate a new key pair for `age` and store it in a secure location (usually `~/.config/chezmoi/key.txt`).

```bash
mkdir -p ~/.config/chezmoi
age-keygen -o ~/.config/chezmoi/key.txt
```

**Output example:**
```text
# created: 2024-01-01T12:00:00Z
# public key: age1ql3z7hjy54pw3hyww5hyww5hyww5hyww5hyww5hyww5hyww5hywsp7d987
AGE-SECRET-KEY-1...
```

**⚠️ IMPORTANT:**
- **Backup this file!** If you lose `key.txt`, you will **lose access** to all your encrypted files.
- **Do not commit** `key.txt` to your git repository.

## 2. Configure Chezmoi

You need to tell `chezmoi` to use this key for encryption.
Open your `~/.config/chezmoi/chezmoi.toml` (or `.yaml`) configuration file.
Since this repository uses a template, you should edit the source template: `home/.chezmoi.yaml.tmpl`.

Add the following configuration (replacing `age1...` with your actual **public key** from step 1):

```yaml
encryption: "age"
age:
    identity: "~/.config/chezmoi/key.txt"
    recipient: "age1ql3z7hjy54pw3hyww5hyww5hyww5hyww5hyww5hyww5hyww5hywsp7d987"
```

Then apply the configuration:
```bash
chezmoi init --apply
```

## 3. Encrypting a File

To encrypt a sensitive file (e.g., `~/.ssh/id_ed25519`), add it with the `--encrypt` flag:

```bash
chezmoi add --encrypt ~/.ssh/id_ed25519
```

This will create a file in your source directory like `private_dot_ssh/encrypted_id_ed25519.age`.

## 4. Decrypting / Using Files

When you run `chezmoi apply` on a machine that has the correct `key.txt` at the configured path, `chezmoi` will automatically decrypt the file and place it in the correct location (`~/.ssh/id_ed25519`).

## 5. Setting Up on a New Machine

1.  **Install `chezmoi` and `age`**.
2.  **Manually copy** your `key.txt` to `~/.config/chezmoi/key.txt` (via USB, secure copy, or password manager).
3.  **Run setup:**
    ```bash
    ./setup.sh
    ```

As long as the key is present, decryption happens transparently.

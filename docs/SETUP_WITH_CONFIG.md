# Setup with Configuration File (`config.env`)

This project supports a configuration-based setup using a `config.env` file. This allows you to customize installation parameters (username, repository URLs, system type) without modifying the source code.

## 1. Prepare Configuration File

Copy the template file to create your local configuration:

```bash
cp config.env.template config.env
```

## 2. Customize Configuration

Edit `config.env` with your preferred settings:

```bash
vi config.env
```

### Key Configuration Variables

| Variable | Description | Default |
| :--- | :--- | :--- |
| `USERNAME` | The username to be created (in Docker) or used. | `nrtkKodama` |
| `GITHUB_USER` | GitHub username for repository cloning. | `nrtkKodama` |
| `DOTFILES_REPO_NAME` | Name of the dotfiles repository. | `dotfiles` |
| `DOTFILES_BRANCH` | Branch to use (e.g., `main`, `master`). | `main` |
| `SYSTEM_TYPE` | System type: `client` (Desktop/macOS) or `server`. | `client` |

## 3. Run Setup

Run the setup script. It will automatically detect and load your `config.env`.

```bash
./setup.sh
```

## 4. Docker Build (Optional)

If you are building the Docker image, you can pass these variables as build arguments, or rely on the defaults defined in the Dockerfile.

```bash
# Example: Build with custom username
docker build --build-arg USERNAME=myuser -t my-dotfiles .
```

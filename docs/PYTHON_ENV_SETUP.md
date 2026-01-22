# Python Development Environment Setup

This guide explains how to set up and use the Docker-based Python development environment located in `environments/python`.
We use `make` to simplify the interaction with Docker Compose.

## 1. Start the Environment

Navigate to the python environment directory and run `make up`.
This will build the image (with your current user ID/GID) and start the container.

```bash
cd environments/python
make up
```

## 2. Access the Shell

Enter the running container (as your standard user):

```bash
make exec
```

If you need to perform administrative tasks (e.g., installing system packages with `apt`), you can enter as **root**:

```bash
make exec-root
```

You are now logged in as the selected user inside the container. The repository root is mounted at `/app`.

## 3. Set up Python with `uv`

Since the container comes with `uv` pre-installed but no specific Python version, you can install and configure the Python version you need.

### Install Python

Install a specific Python version (e.g., 3.12):

```bash
uv python install 3.12
```

### Create a Virtual Environment

Create a virtual environment in the current directory:

```bash
uv venv .venv
```

### Activate the Environment

Activate the virtual environment:

```bash
source .venv/bin/activate
```

## 4. Manage Dependencies

You can now use `uv` to manage your project dependencies.

**Install a package:**
```bash
uv pip install numpy pandas
```

**Run a script:**
```bash
uv run python script.py
```

## 5. Stop the Environment

When you are done, you can stop the container.

```bash
make down
```

To stop and **remove all volumes** (clearing the package cache), use:

```bash
make clean
```

## Troubleshooting

- **Permissions:** The Makefile automatically passes your host `UID` and `GID` to the container. If you still encounter permission issues, try rebuilding the image:
  ```bash
  make build
  make up
  ```
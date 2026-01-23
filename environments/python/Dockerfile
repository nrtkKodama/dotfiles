FROM ubuntu:22.04

# Build arguments for user customization
ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    UV_LINK_MODE=copy

# Install essential packages
# - git, curl: Basic tools
# - build-essential: For compiling Python extensions if needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    vim \
    nano \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/bash

# Switch to the non-root user
USER $USERNAME
WORKDIR /home/$USERNAME

# Install uv as the local user
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Set PATH to include user's local bin
ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"

WORKDIR /app

# Keep container running
CMD ["sleep", "infinity"]

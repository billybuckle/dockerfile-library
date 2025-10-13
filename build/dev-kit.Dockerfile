FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    curl \
    bash-completion \
    build-essential \
    git \
    jq \
    sudo \
    wget \
    ca-certificates \
    vim \
    nano \
    tree \
    htop \
    unzip \
    ssh \
    && rm -rf /var/lib/apt/lists/*

# Install UV for all users
ADD https://astral.sh/uv/install.sh /opt/uv-installer.sh
RUN sh /opt/uv-installer.sh && rm /opt/uv-installer.sh
RUN mv /root/.local/bin/uv /usr/local/bin/uv && \
    mv /root/.local/bin/uvx /usr/local/bin/uvx

# Create the dev user with passwordless sudo
RUN useradd -m -s /bin/bash dev && echo "dev ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chown -R dev:dev /opt

# Install fzf
RUN curl -fsSL https://github.com/junegunn/fzf/releases/download/v0.66.0/fzf-0.66.0-linux_amd64.tar.gz | tar -xz -C /usr/local/bin

# Configure the dev user environment
USER dev

# Configure UV to use a different directory for virtual environments
RUN mkdir -p /home/dev/.cache/uv
RUN mkdir -p /opt/venvs
ENV UV_CACHE_DIR=/home/dev/.cache/uv

RUN git config --global init.defaultBranch main && \
    git config --global core.editor "vim" && \
    git config --global pull.rebase false

# Set up bashrc
ADD ../config/bashrc /home/dev/.bashrc

USER root
# Set development environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV TERM=xterm-256color

WORKDIR /workspace
RUN chown -R dev:dev /workspace
